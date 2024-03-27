// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TodoList{

    enum Status{
        todo,
        doing,
        done
    }

    struct Todo{
        string title;
        string description;
        uint startDate;
        uint endDate;
        Status status;
    }

   
    mapping(address => mapping(uint256 => Todo)) public todos;
    mapping(address => uint256) public TodoId;
    mapping(address => uint256[]) public getId;

    
    event TodoCreated(address indexed user, uint256 indexed todoId, string title, string description, uint256 startDate, uint256 endDate, Status status);
    event TodoDeleted(address indexed user,uint256 indexed  todoId);
    event TodoUpdated(address indexed user, uint256 indexed todoId, string title, string description, uint256 startDate,uint256 endDate, Status status);
    
    function generateTodoId(address user, string memory title, string memory description, uint256 startDate, uint256 endDate, Status status) internal view returns (uint256) {
        bytes32 hash = keccak256(abi.encodePacked(user, title, description, startDate, endDate, status, block.timestamp));
        return uint256(hash);
    }

   
    function createTodo(string memory title, string memory description, uint256 startDate, uint256 endDate, Status status) external returns(string memory,string memory,uint256,uint256,Status){
   
        uint256 newTodoId = generateTodoId(msg.sender, title, description, startDate, endDate, status);

        todos[msg.sender][newTodoId] = Todo({
            title: title,
            description: description,
            startDate: startDate,
            endDate: endDate,
            status: status
        });

        TodoId[msg.sender]++;

        emit TodoCreated(msg.sender, newTodoId, title, description, startDate, endDate, status);
        getId[msg.sender].push(newTodoId);
        return(title,description,startDate,endDate,status);
    }
    
    function deleteTodo(uint256 todoId) external {
        require(todoId == TodoId[msg.sender], "Todo does not exist");

        delete todos[msg.sender][todoId];
        TodoId[msg.sender]--;

        emit TodoDeleted(msg.sender, todoId);
    }
    

    function getTodo(address user) external view returns (Todo[] memory) {
        uint256[] storage tokenIDs = getId[user];
        Todo[] memory userTodos = new Todo[](tokenIDs.length);

        for (uint256 i = 0; i < tokenIDs.length; i++) {
            uint256 tokenID = tokenIDs[i];
            // userTodos[i] = todos[msg.sender][tokenID];
            userTodos[i] = todos[user][tokenID];
        }

        return userTodos;
    }

    function updateTodo(uint256 tokenId,string memory title, string memory description, uint startDate, uint endDate, Status status) external {
        
        todos[msg.sender][tokenId].title = title;
        todos[msg.sender][tokenId].description = description;
        todos[msg.sender][tokenId].startDate = startDate;
        todos[msg.sender][tokenId].endDate = endDate;
        todos[msg.sender][tokenId].status = status;

        emit TodoUpdated(msg.sender, tokenId, title, description, startDate, endDate, status);
    }
   

}