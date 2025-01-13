<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>AI Chat Interface</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .chat-container {
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f4f6f9;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .chat-messages {
            height: 400px;
            overflow-y: auto;
            background-color: white;
            border-radius: 5px;
            padding: 15px;
            margin-bottom: 15px;
        }
        .message {
            margin-bottom: 10px;
            padding: 10px;
            border-radius: 5px;
        }
        .user-message {
            background-color: #e9ecef;
            text-align: right;
        }
        .ai-message {
            background-color: #d1e7dd;
            text-align: left;
        }
    </style>
</head>
<body>
    <div class="container mt-5">
        <div class="chat-container">
            <div class="chat-messages" id="chatMessages"></div>
            
            <form id="chatForm">
                <div class="input-group">
                    <input type="text" id="userQuery" class="form-control" placeholder="Ask me something...">
                    <button type="submit" class="btn btn-primary">Send</button>
                </div>
            </form>

            <div class="mt-3">
                <button id="trainAI" class="btn btn-secondary">Train AI</button>
            </div>
        </div>
    </div>

    <script>
    document.addEventListener('DOMContentLoaded', () => {
        const chatMessages = document.getElementById('chatMessages');
        const chatForm = document.getElementById('chatForm');
        const userQueryInput = document.getElementById('userQuery');
        const trainAIButton = document.getElementById('trainAI');

        function addMessage(message, type) {
            const messageElement = document.createElement('div');
            messageElement.classList.add('message', `${type}-message`);
            messageElement.textContent = message;
            chatMessages.appendChild(messageElement);
            chatMessages.scrollTop = chatMessages.scrollHeight;
        }

        chatForm.addEventListener('submit', async (e) => {
            e.preventDefault();
            const userQuery = userQueryInput.value.trim();
            
            if (!userQuery) return;

            // Display user message
            addMessage(userQuery, 'user');
            userQueryInput.value = '';

            try {
                const response = await fetch('train_ai.php', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: `query=${encodeURIComponent(userQuery)}`
                });

                const data = await response.json();
                addMessage(data.response, 'ai');
            } catch (error) {
                addMessage('Sorry, I encountered an error.', 'ai');
                console.error('Error:', error);
            }
        });

        trainAIButton.addEventListener('click', async () => {
            try {
                const response = await fetch('train_ai.php?train=1');
                const data = await response.json();
                
                if (data.status === 'success') {
                    addMessage(`AI Trained! Vocabulary size: ${data.vocabulary_size}`, 'ai');
                } else {
                    addMessage(`Training failed: ${data.message}`, 'ai');
                }
            } catch (error) {
                addMessage('Training failed.', 'ai');
                console.error('Training error:', error);
            }
        });
    });
    </script>
</body>
</html>