# TaskManagerDart

A in-progress task manager that is meant to help guide and keep track of tasks that could be long, intermediate , or short term.

## Getting Started

Follow the install Guides on the flutter.dev Websites for VS Code
____________________________________________________________
LINK for Windows:

https://docs.flutter.dev/get-started/install/windows/mobile

____________________________________________________________

## Main Class Model

```mermaid
classDiagram
    direction LR

    class MyApp {
        +build(context)
    }

    class MainPage {
        +title: String
        +createState()
    }

    class _MainPageState {
        -tasks: List~Task~
        -taskManager: TaskManager
        -milestoneLabel: String?
        +_addTask()
        +_completeTask(index)
        +_deleteTask(index)
        +_updateTaskTitle(index, newTitle)
        +_showMilestonePopup(rewardLabel)
        +saveTasks()
        +loadTasks()
        +build(context)
    }

    class Task {
        +title: String
        +isCompleted: bool
    }

    class TaskManager {
        +tasks: List~Task~
        +completeTask(index): String?
    }

    class TaskBox {
        +task: Task
        +onComplete: VoidCallback
        +onDelete: VoidCallback
        +onEdit: Function(String)
    }

    MyApp --> MainPage : uses
    MainPage --> _MainPageState : creates
    _MainPageState --> Task : manages
    _MainPageState --> TaskManager : interacts with
    _MainPageState --> TaskBox : builds UI
    TaskBox --> Task : displays

```

##Methods of Model
```mermaid
    classDiagram
    direction LR

    class Task {
        +String title
        +bool isCompleted
        +Task({title, isCompleted})
        +toJson(): Map~String, dynamic~
        +fromJson(Map~String, dynamic~): Task
    }

    class TaskManager {
        +List~Task~ tasks
        +int completedCount
        +List~Map~ milestones
        +addTask(title)
        +completeTask(index): String?
        +deleteTask(index)
        +updateTaskTitle(index, newTitle)
        +toJson(): Map~String, dynamic~
        +fromJson(json)
    }

    TaskManager --> Task : manages
```
##Methods of widgets
```mermaid
    classDiagram
    direction LR

    class Task {
        +String title
        +bool isCompleted
        +toJson()
        +fromJson(json)
    }

    class TaskBox {
        +Task task
        +VoidCallback onComplete
        +VoidCallback onDelete
        +Function(String) onEdit
        +createState(): State
    }

    class _TaskBoxState {
        -bool showOptions
        -bool isEditing
        -TextEditingController _controller
        +initState()
        +dispose()
        +toggleEdit()
        +build(context): Widget
    }

    TaskBox --> Task : uses
    TaskBox --> _TaskBoxState : creates
    _TaskBoxState --> TextEditingController : manages
```

