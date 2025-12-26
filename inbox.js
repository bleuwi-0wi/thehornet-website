/* HORNET INBOX - CORE LOGIC (MVP) */

const MOCK_DB = {
    currentUser: null,
    users: [
        { id: 'user_001', username: 'Bluewi', avatar: 'https://ui-avatars.com/api/?name=Bluewi&background=007bff&color=fff', status: 'online', role: 'admin' },
        { id: 'user_002', username: 'Customer_Design', avatar: 'https://ui-avatars.com/api/?name=Customer&background=dc3545&color=fff', status: 'offline', role: 'member' },
        { id: 'user_003', username: 'Seller_Pro', avatar: 'https://ui-avatars.com/api/?name=Seller&background=28a745&color=fff', status: 'online', role: 'seller' },
        { id: 'user_004', username: 'Support_Agent', avatar: 'https://ui-avatars.com/api/?name=Support&background=ffc107&color=000', status: 'online', role: 'admin' },
        { id: 'user_005', username: 'New_Member', avatar: 'https://ui-avatars.com/api/?name=Member&background=6c757d&color=fff', status: 'online', role: 'member' }
    ],
    conversations: [
        {
            id: 'conv_1',
            type: 'dm',
            participants: ['user_001', 'user_002'],
            last_message: {
                content: 'Hello, I need help with a panel.',
                timestamp: Date.now() - 3600000,
                sender_id: 'user_002',
                seen: false
            },
            unread_count: 1
        },
        {
            id: 'conv_2',
            type: 'dm',
            participants: ['user_001', 'user_003'],
            last_message: {
                content: 'Your order has been shipped!',
                timestamp: Date.now() - 86400000,
                sender_id: 'user_003',
                seen: true
            },
            unread_count: 0
        },
        {
            id: 'conv_3',
            type: 'group',
            participants: ['user_001', 'user_003', 'user_004'],
            group_name: 'Admin Team',
            last_message: {
                content: 'Meeting at 5 PM.',
                timestamp: Date.now() - 172800000,
                sender_id: 'user_004',
                seen: true
            },
            unread_count: 0
        }
    ],
    messages: {
        'conv_1': [
            { id: 'm1', sender_id: 'user_002', content: 'Hi, are you available?', timestamp: Date.now() - 3605000, seen: true },
            { id: 'm2', sender_id: 'user_001', content: 'Yes, what do you need?', timestamp: Date.now() - 3604000, seen: true },
            { id: 'm3', sender_id: 'user_002', content: 'Hello, I need help with a panel.', timestamp: Date.now() - 3600000, seen: false }
        ],
        'conv_2': [
            { id: 'm4', sender_id: 'user_001', content: 'When will it arrive?', timestamp: Date.now() - 86500000, seen: true },
            { id: 'm5', sender_id: 'user_003', content: 'Your order has been shipped!', timestamp: Date.now() - 86400000, seen: true }
        ],
        'conv_3': [
            { id: 'm6', sender_id: 'user_004', content: 'Updates on the new feature?', timestamp: Date.now() - 172900000, seen: true },
            { id: 'm7', sender_id: 'user_003', content: 'Almost done.', timestamp: Date.now() - 172850000, seen: true },
            { id: 'm8', sender_id: 'user_004', content: 'Meeting at 5 PM.', timestamp: Date.now() - 172800000, seen: true }
        ]
    }
};

class HornetInbox {
    constructor() {
        this.currentUser = JSON.parse(localStorage.getItem('hornet_user')) || MOCK_DB.users[0];
        this.activeConversationId = null;
        this.lang = localStorage.getItem('hornets_lang') || 'en';
        this.init();
    }

    t(key) {
        if (window.translations && window.translations[this.lang] && window.translations[this.lang][key]) {
            return window.translations[this.lang][key];
        }
        return key; // Fallback
    }

    setLanguage(lang) {
        this.lang = lang;
        this.renderUI(); // Re-render everything with new language
        if (this.activeConversationId) {
            this.renderChatWindow(this.activeConversationId);
        }
    }

    init() {
        // Load data from LocalStorage or seed if empty
        if (!localStorage.getItem('hornet_conversations')) {
            localStorage.setItem('hornet_conversations', JSON.stringify(MOCK_DB.conversations));
        }
        if (!localStorage.getItem('hornet_messages')) {
            localStorage.setItem('hornet_messages', JSON.stringify(MOCK_DB.messages));
        }

        this.conversations = JSON.parse(localStorage.getItem('hornet_conversations'));
        this.messages = JSON.parse(localStorage.getItem('hornet_messages'));

        this.renderUI();
        this.setupEventListeners();

        const urlParams = new URLSearchParams(window.location.search);
        const startChatWith = urlParams.get('user');
        if (startChatWith) {
            this.startNewChat(startChatWith); // Note: method not implemented in previous pass, but referenced
        }
    }

    // --- RENDERING ---

    renderUI() {
        this.renderSidebar();
        if (this.activeConversationId) {
            this.renderChatWindow(this.activeConversationId);
        } else {
            this.renderEmptyState();
        }
        this.updateUnreadCount();
    }

    renderSidebar() {
        const listContainer = document.querySelector('.conversation-list');
        listContainer.innerHTML = '';

        const sortedConvos = [...this.conversations].sort((a, b) => b.last_message.timestamp - a.last_message.timestamp);

        sortedConvos.forEach(conv => {
            const otherUser = this.getOtherParticipant(conv);
            if (!otherUser && conv.type === 'dm') return;

            const name = conv.type === 'group' ? conv.group_name : otherUser.username;
            const avatar = conv.type === 'group' ? 'https://ui-avatars.com/api/?name=Group' : otherUser.avatar;
            const statusClass = conv.type === 'dm' ? otherUser.status : '';
            const isActive = conv.id === this.activeConversationId ? 'active' : '';

            const date = new Date(conv.last_message.timestamp);
            const timeString = date.toLocaleTimeString(this.lang === 'ar' ? 'ar-SA' : 'en-US', { hour: '2-digit', minute: '2-digit' });

            const youPrefix = conv.last_message.sender_id === this.currentUser.id ? this.t('you') + ': ' : '';

            const html = `
                <div class="conversation-item ${isActive}" data-id="${conv.id}">
                    <div class="avatar-wrapper">
                        <img src="${avatar}" alt="${name}" class="avatar">
                        ${conv.type === 'dm' ? `<span class="status-indicator ${statusClass}"></span>` : ''}
                    </div>
                    <div class="conversation-info">
                        <div class="conversation-top">
                            <h4 class="username">${name}</h4>
                            <span class="time">${timeString}</span>
                        </div>
                        <div class="conversation-bottom">
                            <p class="last-message ${!conv.last_message.seen && conv.last_message.sender_id !== this.currentUser.id ? 'unread' : ''}">
                                ${youPrefix}${conv.last_message.content}
                            </p>
                            ${conv.unread_count > 0 && conv.last_message.sender_id !== this.currentUser.id ? `<span class="unread-badge">${conv.unread_count}</span>` : ''}
                        </div>
                    </div>
                </div>
            `;
            listContainer.insertAdjacentHTML('beforeend', html);
        });
    }

    renderChatWindow(convId) {
        const chatMain = document.querySelector('.chat-main');
        const conv = this.conversations.find(c => c.id === convId);
        if (!conv) return;

        const otherUser = this.getOtherParticipant(conv);
        const name = conv.type === 'group' ? conv.group_name : otherUser.username;

        let statusText = '';
        if (conv.type === 'group') {
            statusText = `${conv.participants.length} ` + (this.lang === 'fr' ? 'membres' : (this.lang === 'ar' ? 'أعضاء' : (this.lang === 'es' || this.lang === 'pt' ? 'miembros' : 'members')));
        } else {
            statusText = this.t(otherUser.status) || otherUser.status;
        }

        const headerInfo = document.querySelector('.chat-header-info');
        if (headerInfo) {
            headerInfo.querySelector('h3').textContent = name;
            headerInfo.querySelector('span').textContent = statusText;
        } else {
            // If coming from empty state, structure might be missing, handled in selectConversation
        }

        // Messages
        const messagesContainer = document.querySelector('.messages-container');
        if (messagesContainer) {
            messagesContainer.innerHTML = '';
            const msgs = this.messages[convId] || [];

            msgs.forEach(msg => {
                const isMe = msg.sender_id === this.currentUser.id;
                const msgHtml = `
                    <div class="message-wrapper ${isMe ? 'message-out' : 'message-in'}">
                        <div class="message-bubble">
                            ${msg.content}
                            <div class="message-meta">
                                <span class="message-time">${new Date(msg.timestamp).toLocaleTimeString(this.lang === 'ar' ? 'ar-SA' : 'en-US', { hour: '2-digit', minute: '2-digit' })}</span>
                                ${isMe ? `<span class="message-status"><i class="fas fa-${msg.seen ? 'check-double' : 'check'}"></i></span>` : ''}
                            </div>
                        </div>
                    </div>
                `;
                messagesContainer.insertAdjacentHTML('beforeend', msgHtml);
            });
            messagesContainer.scrollTop = messagesContainer.scrollHeight;
        }

        if (conv.unread_count > 0) {
            this.markAsRead(convId);
        }
    }

    renderEmptyState() {
        const chatMain = document.querySelector('.chat-main');
        chatMain.innerHTML = `
            <div class="empty-state">
                <div class="empty-icon"><i class="fas fa-paper-plane"></i></div>
                <h2>${this.t('yourMessages')}</h2>
                <p>${this.t('emptyStateDesc')}</p>
                <button class="btn btn-primary" id="startNewChatBtn">${this.t('startNewChat')}</button>
            </div>
        `;
        if (document.getElementById('startNewChatBtn')) {
            document.getElementById('startNewChatBtn').addEventListener('click', () => {
                // Placeholder for logic
                alert(this.t('startNewChat'));
            });
        }
    }

    getOtherParticipant(conv) {
        if (!conv) return null;
        if (conv.type === 'group') return null;
        const otherId = conv.participants.find(id => id !== this.currentUser.id);
        return MOCK_DB.users.find(u => u.id === otherId) || { username: 'Unknown', avatar: 'https://ui-avatars.com/api/?name=?', status: 'offline' };
    }

    selectConversation(id) {
        this.activeConversationId = id;

        // Restore Chat UI if it was empty state
        const chatMain = document.querySelector('.chat-main');
        // Always rebuild chat structure to be safe or if switching from empty
        chatMain.innerHTML = `
            <div class="chat-header">
                <div class="chat-header-info">
                    <h3>...</h3>
                    <span>...</span>
                </div>
                <div class="chat-actions">
                    <button><i class="fas fa-phone"></i></button>
                    <button><i class="fas fa-video"></i></button>
                    <button><i class="fas fa-info-circle"></i></button>
                </div>
            </div>
            <div class="messages-container"></div>
            <div class="chat-input-area">
                <button class="attach-btn"><i class="fas fa-plus"></i></button>
                <input type="text" placeholder="${this.t('typeMessage')}" id="messageInput">
                <button class="emoji-btn"><i class="far fa-smile"></i></button>
                <button class="send-btn" id="sendBtn"><i class="fas fa-paper-plane"></i></button>
            </div>
        `;
        this.setupChatInputListeners();
        this.renderUI();
    }

    // ... (rest of methods like sendMessage remain mostly same)

    sendMessage(text) {
        if (!text.trim() || !this.activeConversationId) return;

        const convId = this.activeConversationId;
        const newMessage = {
            id: 'm_' + Date.now(),
            sender_id: this.currentUser.id,
            content: text,
            timestamp: Date.now(),
            seen: false
        };

        if (!this.messages[convId]) this.messages[convId] = [];
        this.messages[convId].push(newMessage);
        localStorage.setItem('hornet_messages', JSON.stringify(this.messages));

        const convIndex = this.conversations.findIndex(c => c.id === convId);
        if (convIndex > -1) {
            this.conversations[convIndex].last_message = {
                content: text,
                timestamp: newMessage.timestamp,
                sender_id: this.currentUser.id,
                seen: false
            };
            const conv = this.conversations.splice(convIndex, 1)[0];
            this.conversations.unshift(conv);
            localStorage.setItem('hornet_conversations', JSON.stringify(this.conversations));
        }

        this.renderChatWindow(convId);
        this.renderSidebar();

        setTimeout(() => this.simulateReply(convId), 2000 + Math.random() * 3000);
    }

    // Keeping simple versions of other methods for brevity in this replace block helper
    markAsRead(convId) {
        const convIndex = this.conversations.findIndex(c => c.id === convId);
        if (convIndex > -1) {
            this.conversations[convIndex].unread_count = 0;
            this.conversations[convIndex].last_message.seen = true;
            localStorage.setItem('hornet_conversations', JSON.stringify(this.conversations));
            this.updateUnreadCount();
            this.renderSidebar();
        }
    }

    simulateReply(convId) {
        const conv = this.conversations.find(c => c.id === convId);
        if (!conv) return;

        const responses = [
            "That sounds great!", "I'll check on that for you.", "Can you send me the details?",
            "Okay, thanks.", "Awesome work!", "Busy right now, talk later?"
        ];
        const randomResponse = responses[Math.floor(Math.random() * responses.length)];
        const otherUser = this.getOtherParticipant(conv);

        const replyMsg = {
            id: 'm_' + Date.now(), sender_id: otherUser.id, content: randomResponse, timestamp: Date.now(), seen: false
        };

        this.messages[convId].push(replyMsg);
        localStorage.setItem('hornet_messages', JSON.stringify(this.messages));

        conv.last_message = {
            content: randomResponse, timestamp: replyMsg.timestamp, sender_id: otherUser.id, seen: false
        };

        if (this.activeConversationId !== convId) {
            conv.unread_count = (conv.unread_count || 0) + 1;
        }

        const idx = this.conversations.indexOf(conv);
        this.conversations.splice(idx, 1);
        this.conversations.unshift(conv);
        localStorage.setItem('hornet_conversations', JSON.stringify(this.conversations));

        if (this.activeConversationId === convId) {
            this.renderChatWindow(convId);
        }
        this.renderSidebar();
    }

    updateUnreadCount() { }

    setupEventListeners() {
        document.querySelector('.conversation-list').addEventListener('click', (e) => {
            const item = e.target.closest('.conversation-item');
            if (item) {
                this.selectConversation(item.dataset.id);
            }
        });
    }

    setupChatInputListeners() {
        const input = document.getElementById('messageInput');
        const sendBtn = document.getElementById('sendBtn');
        const send = () => {
            const text = input.value;
            this.sendMessage(text);
            input.value = '';
        };
        if (sendBtn && input) {
            sendBtn.addEventListener('click', send);
            input.addEventListener('keypress', (e) => {
                if (e.key === 'Enter') send();
            });
        }
    }

    startNewChat(userId) {
        // Basic start chat implementation
        const user = MOCK_DB.users.find(u => u.id === userId || u.username === userId);
        if (user) {
            // check if conv exists
            let conv = this.conversations.find(c => c.participants.includes(user.id) && c.type === 'dm');
            if (!conv) {
                conv = {
                    id: 'conv_' + Date.now(),
                    type: 'dm',
                    participants: [this.currentUser.id, user.id],
                    last_message: { content: 'Started a new conversation', timestamp: Date.now(), sender_id: this.currentUser.id, seen: true },
                    unread_count: 0
                };
                this.conversations.unshift(conv);
                // Initialize empty messages
                this.messages[conv.id] = [];
                localStorage.setItem('hornet_conversations', JSON.stringify(this.conversations));
                localStorage.setItem('hornet_messages', JSON.stringify(this.messages));
            }
            this.selectConversation(conv.id);
        }
    }
}

document.addEventListener('DOMContentLoaded', () => {
    window.HornetInboxApp = new HornetInbox();
});
