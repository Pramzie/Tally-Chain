// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title TodoListManager
 * @dev A decentralized to-do list manager where each user can create, complete, and delete their own tasks
 */
contract TodoListManager {
    
    // Structure to represent a task
    struct Task {
        uint256 id;
        string description;
        bool isCompleted;
        uint256 createdAt;
        uint256 completedAt;
    }
    
    // Mapping from user address to their task counter
    mapping(address => uint256) private userTaskCounter;
    
    // Mapping from user address to mapping of task ID to Task
    mapping(address => mapping(uint256 => Task)) private userTasks;
    
    // Mapping from user address to array of task IDs (for easier enumeration)
    mapping(address => uint256[]) private userTaskIds;
    
    // Events
    event TaskCreated(address indexed user, uint256 indexed taskId, string description);
    event TaskCompleted(address indexed user, uint256 indexed taskId);
    event TaskDeleted(address indexed user, uint256 indexed taskId);
    event TaskUpdated(address indexed user, uint256 indexed taskId, string newDescription);
    
    // Modifiers
    modifier taskExists(uint256 _taskId) {
        require(userTasks[msg.sender][_taskId].id != 0, "Task does not exist");
        _;
    }
    
    modifier taskNotCompleted(uint256 _taskId) {
        require(!userTasks[msg.sender][_taskId].isCompleted, "Task is already completed");
        _;
    }
    
    modifier validDescription(string memory _description) {
        require(bytes(_description).length > 0, "Task description cannot be empty");
        require(bytes(_description).length <= 500, "Task description too long");
        _;
    }
    
    /**
     * @dev Create a new task
     * @param _description The description of the task
     * @return taskId The ID of the newly created task
     */
    function createTask(string memory _description) 
        external 
        validDescription(_description) 
        returns (uint256 taskId) 
    {
        userTaskCounter[msg.sender]++;
        taskId = userTaskCounter[msg.sender];
        
        userTasks[msg.sender][taskId] = Task({
            id: taskId,
            description: _description,
            isCompleted: false,
            createdAt: block.timestamp,
            completedAt: 0
        });
        
        userTaskIds[msg.sender].push(taskId);
        
        emit TaskCreated(msg.sender, taskId, _description);
    }
    
    /**
     * @dev Complete a task
     * @param _taskId The ID of the task to complete
     */
    function completeTask(uint256 _taskId) 
        external 
        taskExists(_taskId) 
        taskNotCompleted(_taskId) 
    {
        userTasks[msg.sender][_taskId].isCompleted = true;
        userTasks[msg.sender][_taskId].completedAt = block.timestamp;
        
        emit TaskCompleted(msg.sender, _taskId);
    }
    
    /**
     * @dev Delete a task
     * @param _taskId The ID of the task to delete
     */
    function deleteTask(uint256 _taskId) 
        external 
        taskExists(_taskId) 
    {
        // Remove from userTaskIds array
        uint256[] storage taskIds = userTaskIds[msg.sender];
        for (uint256 i = 0; i < taskIds.length; i++) {
            if (taskIds[i] == _taskId) {
                taskIds[i] = taskIds[taskIds.length - 1];
                taskIds.pop();
                break;
            }
        }
        
        // Delete the task
        delete userTasks[msg.sender][_taskId];
        
        emit TaskDeleted(msg.sender, _taskId);
    }
    
    /**
     * @dev Update a task's description
     * @param _taskId The ID of the task to update
     * @param _newDescription The new description for the task
     */
    function updateTask(uint256 _taskId, string memory _newDescription) 
        external 
        taskExists(_taskId) 
        taskNotCompleted(_taskId)
        validDescription(_newDescription) 
    {
        userTasks[msg.sender][_taskId].description = _newDescription;
        
        emit TaskUpdated(msg.sender, _taskId, _newDescription);
    }
    
    /**
     * @dev Get a specific task
     * @param _taskId The ID of the task to retrieve
     * @return task The task details
     */
    function getTask(uint256 _taskId) 
        external 
        view 
        taskExists(_taskId) 
        returns (Task memory task) 
    {
        return userTasks[msg.sender][_taskId];
    }
    
    /**
     * @dev Get all task IDs for the caller
     * @return taskIds Array of task IDs belonging to the caller
     */
    function getAllTaskIds() 
        external 
        view 
        returns (uint256[] memory taskIds) 
    {
        return userTaskIds[msg.sender];
    }
    
    /**
     * @dev Get all tasks for the caller
     * @return tasks Array of all tasks belonging to the caller
     */
    function getAllTasks() 
        external 
        view 
        returns (Task[] memory tasks) 
    {
        uint256[] memory taskIds = userTaskIds[msg.sender];
        tasks = new Task[](taskIds.length);
        
        for (uint256 i = 0; i < taskIds.length; i++) {
            tasks[i] = userTasks[msg.sender][taskIds[i]];
        }
        
        return tasks;
    }
    
    /**
     * @dev Get completed tasks for the caller
     * @return completedTasks Array of completed tasks
     */
    function getCompletedTasks() 
        external 
        view 
        returns (Task[] memory completedTasks) 
    {
        uint256[] memory taskIds = userTaskIds[msg.sender];
        uint256 completedCount = 0;
        
        // Count completed tasks
        for (uint256 i = 0; i < taskIds.length; i++) {
            if (userTasks[msg.sender][taskIds[i]].isCompleted) {
                completedCount++;
            }
        }
        
        // Create array of completed tasks
        completedTasks = new Task[](completedCount);
        uint256 index = 0;
        
        for (uint256 i = 0; i < taskIds.length; i++) {
            if (userTasks[msg.sender][taskIds[i]].isCompleted) {
                completedTasks[index] = userTasks[msg.sender][taskIds[i]];
                index++;
            }
        }
        
        return completedTasks;
    }
    
    /**
     * @dev Get pending (incomplete) tasks for the caller
     * @return pendingTasks Array of pending tasks
     */
    function getPendingTasks() 
        external 
        view 
        returns (Task[] memory pendingTasks) 
    {
        uint256[] memory taskIds = userTaskIds[msg.sender];
        uint256 pendingCount = 0;
        
        // Count pending tasks
        for (uint256 i = 0; i < taskIds.length; i++) {
            if (!userTasks[msg.sender][taskIds[i]].isCompleted) {
                pendingCount++;
            }
        }
        
        // Create array of pending tasks
        pendingTasks = new Task[](pendingCount);
        uint256 index = 0;
        
        for (uint256 i = 0; i < taskIds.length; i++) {
            if (!userTasks[msg.sender][taskIds[i]].isCompleted) {
                pendingTasks[index] = userTasks[msg.sender][taskIds[i]];
                index++;
            }
        }
        
        return pendingTasks;
    }
    
    /**
     * @dev Get the total number of tasks for the caller
     * @return count Total number of tasks
     */
    function getTaskCount() 
        external 
        view 
        returns (uint256 count) 
    {
        return userTaskIds[msg.sender].length;
    }
    
    /**
     * @dev Get task statistics for the caller
     * @return total Total number of tasks
     * @return completed Number of completed tasks
     * @return pending Number of pending tasks
     */
    function getTaskStats() 
        external 
        view 
        returns (uint256 total, uint256 completed, uint256 pending) 
    {
        uint256[] memory taskIds = userTaskIds[msg.sender];
        total = taskIds.length;
        completed = 0;
        
        for (uint256 i = 0; i < taskIds.length; i++) {
            if (userTasks[msg.sender][taskIds[i]].isCompleted) {
                completed++;
            }
        }
        
        pending = total - completed;
        
        return (total, completed, pending);
    }
}