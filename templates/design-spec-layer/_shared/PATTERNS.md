# Implementation Patterns

This document defines the standard patterns used across all features in this project.

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────┐
│  Feature Modules (UI + ViewModel)                                    │
│  MVI: State, Event, Action                                           │
└─────────────────────────────────────────────────────────────────────┘
                    ↓ Uses
┌─────────────────────────────────────────────────────────────────────┐
│  core/domain - Use Cases                                             │
│  Single responsibility, invoke() operator, Paging support            │
└─────────────────────────────────────────────────────────────────────┘
                    ↓ Uses
┌─────────────────────────────────────────────────────────────────────┐
│  core/data - Repository Implementations                              │
│  Combines network + database, DTO→Domain mapping                     │
└─────────────────────────────────────────────────────────────────────┘
                    ↓ Uses
┌─────────────────────────────────────────────────────────────────────┐
│  core/network - Services + DTOs                                      │
│  Flow-based APIs, RPC calls                                          │
└─────────────────────────────────────────────────────────────────────┘
```

---

## MVI Pattern

### ViewModel Structure

```kotlin
class FeatureViewModel(
    private val useCase: GetFeatureUseCase,
) : BaseViewModel<FeatureState, FeatureEvent, FeatureAction>(
    initialState = FeatureState(),
) {
    init {
        loadData()
    }

    override fun handleAction(action: FeatureAction) {
        when (action) {
            is FeatureAction.OnItemClick -> {
                sendEvent(FeatureEvent.NavigateToDetail(action.id))
            }
            is FeatureAction.OnRefresh -> loadData()
        }
    }

    private fun loadData() {
        launchCatching {
            mutableStateFlow.update { it.copy(isLoading = true) }
            val data = useCase().first()
            mutableStateFlow.update {
                it.copy(isLoading = false, items = data)
            }
        }
    }
}
```

### State, Event, Action

```kotlin
// State - UI state, collected via collectAsStateWithLifecycle()
data class FeatureState(
    val items: List<Item> = emptyList(),
    val isLoading: Boolean = false,
    val error: String? = null,
)

// Event - One-shot navigation/effects, handled via EventsEffect()
sealed interface FeatureEvent {
    data class NavigateToDetail(val id: String) : FeatureEvent
    data object ShowError : FeatureEvent
}

// Action - User interactions, sent via viewModel.trySendAction()
sealed interface FeatureAction {
    data class OnItemClick(val id: String) : FeatureAction
    data object OnRefresh : FeatureAction
}
```

### Screen Pattern

```kotlin
@Composable
fun FeatureScreen(
    navigateToDetail: (String) -> Unit,
    viewModel: FeatureViewModel = koinViewModel(),
) {
    val state by viewModel.stateFlow.collectAsStateWithLifecycle()

    EventsEffect(viewModel.eventFlow) { event ->
        when (event) {
            is FeatureEvent.NavigateToDetail -> navigateToDetail(event.id)
        }
    }

    FeatureScreenContent(
        state = state,
        onAction = viewModel::trySendAction,
    )
}

@Composable
private fun FeatureScreenContent(
    state: FeatureState,
    onAction: (FeatureAction) -> Unit,
) {
    // UI implementation
}
```

---

## Pagination Pattern

### Critical Rule

```
UseCase: Creates Pager, returns Flow
ViewModel: Exposes Flow directly (NO stateIn!)
Screen: Collects as LazyPagingItems
```

### UseCase with Paging

```kotlin
class GetItemsFlowUseCase(
    private val repository: ItemsRepository,
) {
    operator fun invoke(pageSize: Int = 20): Flow<PagingData<Item>> {
        return Pager(
            config = PagingConfig(
                pageSize = pageSize,
                enablePlaceholders = false,
            ),
            pagingSourceFactory = { repository.getItemsPagingSource() },
        ).flow
    }
}
```

### ViewModel with Paging

```kotlin
class ItemsViewModel(
    private val getItemsUseCase: GetItemsFlowUseCase,
) : BaseViewModel<ItemsState, ItemsEvent, ItemsAction>(...) {

    // Direct flow exposure - NO stateIn!
    val items: Flow<PagingData<Item>> = getItemsUseCase()
}
```

### Screen with Paging

```kotlin
@Composable
fun ItemsScreen(viewModel: ItemsViewModel = koinViewModel()) {
    val items = viewModel.items.collectAsLazyPagingItems()

    LazyColumn {
        items(
            count = items.itemCount,
            key = items.itemKey { it.id },
        ) { index ->
            items[index]?.let { item ->
                ItemCard(item = item)
            }
        }

        // Handle loading states
        when (items.loadState.refresh) {
            is LoadState.Loading -> item { LoadingIndicator() }
            is LoadState.Error -> item { ErrorMessage() }
            else -> {}
        }
    }
}
```

---

## Layer Patterns

### Network Layer (core/network)

```kotlin
// Service Interface
interface FeatureService {
    fun getItemsFlow(limit: Int, offset: Int): Flow<List<ItemDto>>
    suspend fun getItemById(id: String): ItemDto?
}

// Service Implementation
internal class FeatureServiceImpl(
    private val client: SupabaseClient,
) : FeatureService {

    override fun getItemsFlow(limit: Int, offset: Int): Flow<List<ItemDto>> {
        return client.postgrest
            .from("items")
            .selectAsFlow(
                request = {
                    limit(limit)
                    range(offset.toLong(), (offset + limit - 1).toLong())
                },
            )
    }
}

// DTO
@Serializable
data class ItemDto(
    @SerialName("id") val id: String,
    @SerialName("name") val name: String,
    @SerialName("created_at") val createdAt: String,
)
```

### Data Layer (core/data)

```kotlin
// Repository Interface
interface FeatureRepository {
    fun getItemsFlow(): Flow<List<Item>>
    fun getItemsPagingSource(): PagingSource<Int, Item>
}

// Repository Implementation - NEVER import SupabaseClient!
internal class FeatureRepositoryImpl(
    private val featureService: FeatureService,  // Use service, not client!
) : FeatureRepository {

    override fun getItemsFlow(): Flow<List<Item>> {
        return featureService.getItemsFlow(limit = 100, offset = 0)
            .map { dtos -> dtos.map { it.toDomainModel() } }
    }

    override fun getItemsPagingSource(): PagingSource<Int, Item> {
        return ItemsPagingSource(featureService)
    }
}

// Mapper
fun ItemDto.toDomainModel(): Item = Item(
    id = id,
    name = name,
    createdAt = createdAt.toLocalDateTime(),
)
```

### Domain Layer (core/domain)

```kotlin
class GetItemUseCase(
    private val repository: FeatureRepository,
) {
    suspend operator fun invoke(id: String): Item? {
        return repository.getItemById(id)
    }
}
```

---

## Navigation Pattern

### Route Definition

```kotlin
@Serializable
data object FeatureRoute

fun NavController.navigateToFeature(navOptions: NavOptions? = null) {
    navigate(FeatureRoute, navOptions)
}

fun NavGraphBuilder.featureDestination(
    navigateBack: () -> Unit,
    navigateToDetail: (String) -> Unit,
) {
    composableWithStayTransitions<FeatureRoute> {
        FeatureScreen(
            navigateBack = navigateBack,
            navigateToDetail = navigateToDetail,
        )
    }
}
```

### Transition Helpers

```kotlin
composableWithStayTransitions<Route>()   // No animation
composableWithSlideTransitions<Route>()  // Slide up/down
composableWithPushTransitions<Route>()   // Push left/right
```

---

## DI Pattern (Koin)

### Module Definition

```kotlin
val FeatureModule = module {
    // Service
    singleOf(::FeatureServiceImpl) bind FeatureService::class

    // Repository
    singleOf(::FeatureRepositoryImpl) bind FeatureRepository::class

    // UseCase
    factoryOf(::GetItemsFlowUseCase)

    // ViewModel
    viewModelOf(::FeatureViewModel)
}
```

### Module Registration

```kotlin
// In KoinModules.kt
private val featureModules = module {
    includes(
        FeatureModule,
        // ... other feature modules
    )
}

val allModules = listOf(
    coreModules,
    featureModules,
)
```

---

## Preview Pattern

### All Components Must Have Previews

```kotlin
@Preview
@Composable
private fun ItemCardPreview() {
    MaterialTheme {
        ItemCard(
            item = Item(
                id = "1",
                name = "Sample Item",
                createdAt = LocalDateTime.now(),
            ),
            onClick = {},
        )
    }
}

@Preview
@Composable
private fun FeatureScreenContentPreview() {
    MaterialTheme {
        FeatureScreenContent(
            state = FeatureState(
                items = listOf(
                    Item("1", "Item 1", LocalDateTime.now()),
                    Item("2", "Item 2", LocalDateTime.now()),
                ),
            ),
            onAction = {},
        )
    }
}
```

---

## Error Handling Pattern

```kotlin
// In ViewModel
private fun loadData() {
    launchCatching(
        onError = { error ->
            mutableStateFlow.update {
                it.copy(isLoading = false, error = error.message)
            }
        }
    ) {
        mutableStateFlow.update { it.copy(isLoading = true, error = null) }
        val data = useCase().first()
        mutableStateFlow.update { it.copy(isLoading = false, items = data) }
    }
}
```

---

## Logging Pattern

```kotlin
import co.touchlab.kermit.Logger

private val logger = Logger.withTag("FeatureViewModel")

// Usage
logger.d { "Loading data with id: $id" }
logger.i { "Data loaded successfully: ${items.size} items" }
logger.w { "Cache miss, fetching from network" }
logger.e(exception) { "Failed to load data" }
```
