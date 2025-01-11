// grid_handler.js
class ArticleGridHandler {
    constructor() {
        this.currentPage = 0;
        this.loading = false;
        this.initializeScrollListener();
        this.initializeTrainingHandlers();
    }

    initializeScrollListener() {
        window.addEventListener('scroll', () => {
            if ((window.innerHeight + window.scrollY) >= document.body.offsetHeight - 1000) {
                this.loadMoreArticles();
            }
        });
    }

    async loadMoreArticles() {
        if (this.loading) return;
        this.loading = true;

        try {
            const response = await fetch(`get_articles.php?page=${this.currentPage + 1}`);
            const data = await response.json();
            
            if (data.articles.length > 0) {
                this.appendArticles(data.articles);
                this.currentPage++;
            }
        } catch (error) {
            console.error('Error loading articles:', error);
        } finally {
            this.loading = false;
        }
    }

    appendArticles(articles) {
        const grid = document.querySelector('.article-grid');
        const newRow = document.createElement('div');
        newRow.className = 'grid-row';
        
        articles.forEach(article => {
            newRow.appendChild(this.createArticleCard(article));
        });
        
        grid.appendChild(newRow);
    }

    initializeTrainingHandlers() {
        document.addEventListener('click', (e) => {
            if (e.target.classList.contains('btn-train')) {
                this.handleTraining(e.target.closest('.article-card').dataset.id);
            } else if (e.target.classList.contains('btn-correct')) {
                this.showCorrectionForm(e.target.closest('.article-card').dataset.id);
            }
        });
    }

    async handleTraining(articleId) {
        try {
            const response = await fetch('train_ai.php', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({ articleId })
            });
            const data = await response.json();
            if (data.success) {
                this.updateTrainingVisuals(articleId, data);
            }
        } catch (error) {
            console.error('Training error:', error);
        }
    }
}

// Initialize on page load
document.addEventListener('DOMContentLoaded', () => {
    window.gridHandler = new ArticleGridHandler();
});