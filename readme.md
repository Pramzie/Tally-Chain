

# 📝 TallyChain – A Decentralized To-Do List dApp

A fully on-chain decentralized to-do list manager built in Solidity, allowing individual Ethereum addresses to create, update, complete, and delete their own tasks.

---

## 🚀 Overview

`TodoListManager` is a smart contract that enables users to manage their personal task list in a decentralized and censorship-resistant manner. Tasks are stored on-chain, and only the user (i.e., the wallet that created the task) can manage their own to-do items.

Each task includes:

* A unique ID (per user)
* A short description
* Completion status
* Timestamps for creation and completion

---

## 🛠️ Features

* ✅ Create new tasks with unique IDs
* ✅ Mark tasks as completed
* ✅ Delete tasks
* ✅ Update task descriptions (only before completion)
* ✅ Fetch individual tasks
* ✅ Retrieve lists of:

  * All tasks
  * Completed tasks
  * Pending tasks
* ✅ Get task statistics (total, completed, pending)

---

## 📄 Contract Details

* **Language:** Solidity `^0.8.19`
* **License:** MIT
* **Contract Name:** `TodoListManager`

---

## 📦 Functions

### Task Lifecycle

| Function                                              | Description                                                |
| ----------------------------------------------------- | ---------------------------------------------------------- |
| `createTask(string _description)`                     | Creates a new task with the provided description.          |
| `completeTask(uint256 _taskId)`                       | Marks a task as completed.                                 |
| `deleteTask(uint256 _taskId)`                         | Permanently deletes a task.                                |
| `updateTask(uint256 _taskId, string _newDescription)` | Updates the description of a task (only if not completed). |

### Task Retrieval

| Function                   | Returns                                  |
| -------------------------- | ---------------------------------------- |
| `getTask(uint256 _taskId)` | Details of a specific task.              |
| `getAllTaskIds()`          | List of all task IDs for the caller.     |
| `getAllTasks()`            | List of all task structs.                |
| `getCompletedTasks()`      | List of all completed tasks.             |
| `getPendingTasks()`        | List of all incomplete tasks.            |
| `getTaskCount()`           | Total number of tasks created.           |
| `getTaskStats()`           | (Total, Completed, Pending) task counts. |

---

## 🧠 Data Structure

Each user (i.e., `msg.sender`) maintains:

```solidity
mapping(address => mapping(uint256 => Task)) userTasks;
mapping(address => uint256[]) userTaskIds;
mapping(address => uint256) userTaskCounter;
```

The `Task` struct:

```solidity
struct Task {
    uint256 id;
    string description;
    bool isCompleted;
    uint256 createdAt;
    uint256 completedAt;
}
```

---

## ⚠️ Validations & Modifiers

* Task descriptions must be non-empty and ≤ 500 characters.
* Only uncompleted tasks can be updated.
* Only existing tasks can be acted upon.
* Task IDs are **unique per user**, starting from 1.

---

## 🔐 Security Considerations

* 💡 All tasks are tied to `msg.sender`. No admin access.
* 🛑 No ability for any third-party to view or manage your tasks (except by directly reading from the blockchain).
* 🧱 All task data is permanently stored on-chain unless explicitly deleted by the user.

---

## 🧪 Local Development & Testing

You can test this smart contract using tools like:

* [Remix IDE](https://remix.ethereum.org/)
* Hardhat + Ethers.js
* Foundry (for advanced testing)

### Deploying on Remix

1. Copy the contract into Remix.
2. Compile using Solidity version `0.8.19`.
3. Deploy using an injected Web3 wallet (e.g., MetaMask).
4. Use the GUI to interact with your own task list.

---

## 🌐 Potential Use Cases

* Decentralized productivity tools
* On-chain reputation systems
* DAO contribution tracking
* Permanent public to-do lists

---

## 📜 License

This project is licensed under the [MIT License](LICENSE).

---



Contract Details: 0xD4E496236F24BCf1ef93DD8EDa9EA7ea402b9E89
![Screenshot 2025-05-26 141544](https://github.com/user-attachments/assets/9d3af8b4-4303-44b4-8187-cdb61872cb79)



