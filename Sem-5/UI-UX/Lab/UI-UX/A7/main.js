let taskId = 0;
let editingTask = null;

function addTask(event) {
    event.preventDefault();
    
    const title = document.getElementById("title").value;
    const description = document.getElementById("description").value;
    
    if (title && description) {
        const tasksList = document.getElementById("tasks");
        const newTask = document.createElement("li");
        
        newTask.innerHTML = title + ": " + description + 
            " <button onclick='completeTask(this)'>Done</button>" +
            " <button onclick='editTask(this)'>Edit</button>" +
            " <button onclick='deleteTask(this)'>Delete</button>";
        
        tasksList.appendChild(newTask);
        
        document.getElementById("title").value = '';
        document.getElementById("description").value = '';
    }
}

function deleteTask(button) {
    button.parentElement.remove();
}

function completeTask(button) {
    const task = button.parentElement;
    if (task.style.textDecoration === "line-through") {
        task.style.textDecoration = "";
    } else {
        task.style.textDecoration = "line-through";
    }
}

function editTask(button) {
    const task = button.parentElement;
    const text = task.firstChild.textContent;
    const parts = text.split(": ");
    
    document.getElementById("edit-title").value = parts[0];
    document.getElementById("edit-description").value = parts[1];
    
    editingTask = task;
    document.getElementById("edit-modal").style.display = "block";
}

function updateTask(event) {
    event.preventDefault();
    
    const newTitle = document.getElementById("edit-title").value;
    const newDescription = document.getElementById("edit-description").value;
    
    if (editingTask && newTitle && newDescription) {
        editingTask.innerHTML = newTitle + ": " + newDescription + 
            " <button onclick='completeTask(this)'>Done</button>" +
            " <button onclick='editTask(this)'>Edit</button>" +
            " <button onclick='deleteTask(this)'>Delete</button>";
        
        document.getElementById("edit-modal").style.display = "none";
        editingTask = null;
    }
}


document.addEventListener("DOMContentLoaded", function() {
    document.querySelector("form").addEventListener("submit", addTask);
    document.getElementById("edit-form").addEventListener("submit", updateTask);
    document.getElementById("cancel-edit").addEventListener("click", closeModal);
    document.querySelector(".close").addEventListener("click", closeModal);
});

function closeModal() {
    document.getElementById("edit-modal").style.display = "none";
    editingTask = null;
}
