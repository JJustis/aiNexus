// sensory.js
class SensoryInterface {
    constructor() {
        this.audioContext = null;
        this.videoContext = document.getElementById('videoFeedback')?.getContext('2d');
        this.motionData = document.querySelector('.motion-data');
        this.isProcessing = false;
        this.retryTimeout = null;
        this.initializeAudio();
    }

    initializeAudio() {
        try {
            this.audioContext = new (window.AudioContext || window.webkitAudioContext)();
            this.analyser = this.audioContext.createAnalyser();
            this.analyser.fftSize = 256;
            this.audioData = new Uint8Array(this.analyser.frequencyBinCount);
        } catch (e) {
            console.log('Audio initialization skipped:', e);
        }
    }

    async updateSensoryData() {
        if (this.isProcessing) return;
        this.isProcessing = true;

        try {
            // Update audio visualization if available
            if (this.audioContext && this.analyser) {
                this.analyser.getByteFrequencyData(this.audioData);
                const audioLevel = this.getAverageAudioLevel();
                this.updateModuleProgress('audioModule', audioLevel);
            }

            // Only try to process sensory data if we have some data to process
            if (this.hasActiveSensors()) {
                await this.processSensoryData();
            }
        } catch (error) {
            console.log('Sensory processing paused:', error);
            // Set a retry timeout instead of continuous polling
            if (this.retryTimeout) clearTimeout(this.retryTimeout);
            this.retryTimeout = setTimeout(() => this.updateSensoryData(), 5000);
            return;
        } finally {
            this.isProcessing = false;
        }

        // Continue the animation frame only if we haven't encountered errors
        requestAnimationFrame(() => this.updateSensoryData());
    }

    hasActiveSensors() {
        return this.audioContext || this.videoContext || window.DeviceMotionEvent;
    }

async processSensoryData() {
    const sensorData = {
        audioLevel: this.getAverageAudioLevel(),
        motionData: this.getMotionData()
    };

    try {
        const response = await fetch('process_sensory.php', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(sensorData)
        });

        // Check if response is ok
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }

        // Try to parse the JSON response
        const data = await response.json();
        
        if (data.success) {
            this.updateVisualizations(data);
        } else {
            console.log('Processing returned error:', data.error);
        }
    } catch (error) {
        console.log('Sensory processing error:', error);
        // Use default values on error
        this.updateVisualizations({
            levels: [0, 0, 0],
            audio: new Array(32).fill(0)
        });
    }
}

    getAverageAudioLevel() {
        if (!this.audioData) return 0;
        return Array.from(this.audioData).reduce((a, b) => a + b, 0) / this.audioData.length;
    }

    getMotionData() {
        return [0, 0, 0]; // Default values if no motion data available
    }

    updateModuleProgress(moduleId, level) {
        const progressBar = document.querySelector(`#${moduleId} .progress-bar`);
        if (progressBar) {
            progressBar.style.width = `${(level/255) * 100}%`;
        }
    }

    updateVisualizations(data) {
        if (!data || !data.levels) return;

        // Update module progress bars
        const modules = ['audioModule', 'videoModule', 'motionModule'];
        data.levels.forEach((level, index) => {
            if (modules[index]) {
                this.updateModuleProgress(modules[index], level);
            }
        });

        // Update audio visualization if we have audio data
        if (data.audio && this.audioContext) {
            const audioLevels = document.querySelector('.audio-levels');
            if (audioLevels) {
                audioLevels.innerHTML = this.createAudioBars(data.audio);
            }
        }
    }

    createAudioBars(audioData) {
        return audioData
            .map(level => `<div class="audio-bar" style="height: ${level}%"></div>`)
            .join('');
    }

    start() {
        this.updateSensoryData();
    }
}

// Initialize only if DOM is ready
document.addEventListener('DOMContentLoaded', () => {
    const sensoryInterface = new SensoryInterface();
    sensoryInterface.start();
});