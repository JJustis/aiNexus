class SensoryInterface {
    constructor() {
        this.audioContext = null;
        this.analyser = null;
        this.videoElement = document.getElementById('videoFeedback');
        this.motionCanvas = document.getElementById('motionCanvas');
        this.motionContext = this.motionCanvas?.getContext('2d');
        this.previousFrame = null;
        this.isProcessing = false;
        
        this.initializeAudio();
        this.initializeVideo();
    }
processSensoryData() {
    if (this.isProcessing) return;
    this.isProcessing = true;

    // Ensure audioData is properly initialized
    if (!this.audioData || !this.analyser) {
        console.error('Audio data or analyser not initialized');
        this.isProcessing = false;
        return;
    }

    try {
        // Ensure the Uint8Array is the correct size
        if (!(this.audioData instanceof Uint8Array) || 
            this.audioData.length !== this.analyser.frequencyBinCount) {
            this.audioData = new Uint8Array(this.analyser.frequencyBinCount);
        }

        this.analyser.getByteFrequencyData(this.audioData);
        const audioLevel = this.getAverageLevel(this.audioData);
        this.updateAudioVisualization(this.audioData);
        this.calculateSoundDirection(this.audioData);
    } catch (error) {
        console.error('Error processing audio data:', error);
    }
    async initializeAudio() {
        try {
            this.audioContext = new (window.AudioContext || window.webkitAudioContext)();
            this.analyser = this.audioContext.createAnalyser();
            this.analyser.fftSize = 256;
            
            const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
            const source = this.audioContext.createMediaStreamSource(stream);
            source.connect(this.analyser);
            
            this.audioData = new Uint8Array(this.analyser.frequencyBinCount);
        } catch (e) {
            console.error('Audio initialization failed:', e);
        }
    }

    async initializeVideo() {
        try {
            const stream = await navigator.mediaDevices.getUserMedia({ 
                video: { width: 320, height: 240 } 
            });
            this.videoElement.srcObject = stream;
            this.videoElement.play();
        } catch (e) {
            console.error('Video initialization failed:', e);
        }
    }

    processSensoryData() {
        if (this.isProcessing) return;
        this.isProcessing = true;

        // Process audio
        if (this.analyser) {
            this.analyser.getByteFrequencyData(this.audioData);
            const audioLevel = this.getAverageLevel(this.audioData);
            this.updateAudioVisualization(this.audioData);
            this.calculateSoundDirection(this.audioData);
        }

        // Process video
        if (this.videoElement && this.motionContext) {
            this.detectMotion();
        }

        // Send data to server
        this.sendSensoryData();

        this.isProcessing = false;
        requestAnimationFrame(() => this.processSensoryData());
    }

    getAverageLevel(data) {
        return data.reduce((a, b) => a + b, 0) / data.length;
    }

    updateAudioVisualization(audioData) {
        const container = document.querySelector('.audio-levels');
        if (!container) return;

        const bars = Array.from(audioData).slice(0, 32).map(level => {
            const height = (level / 255) * 100;
            return `<div class="audio-bar" style="height: ${height}%"></div>`;
        }).join('');

        container.innerHTML = bars;
        
        document.getElementById('audioIntensity').textContent = 
            `${Math.round(this.getAverageLevel(audioData) / 255 * 100)}%`;
    }

    detectMotion() {
        this.motionContext.drawImage(this.videoElement, 0, 0);
        const frame = this.motionContext.getImageData(0, 0, 320, 240);

        if (this.previousFrame) {
            const motionData = this.calculateMotion(frame.data, this.previousFrame.data);
            this.updateMotionDisplay(motionData);
        }

        this.previousFrame = frame;
    }

    calculateMotion(current, previous) {
        let diffX = 0, diffY = 0, totalDiff = 0;
        let width = 320, height = 240;

        for (let y = 0; y < height; y++) {
            for (let x = 0; x < width; x++) {
                const i = (y * width + x) * 4;
                const diff = Math.abs(current[i] - previous[i]);
                if (diff > 30) {
                    diffX += x;
                    diffY += y;
                    totalDiff++;
                }
            }
        }

        return totalDiff ? {
            x: diffX / totalDiff,
            y: diffY / totalDiff,
            intensity: totalDiff / (width * height)
        } : { x: 0, y: 0, intensity: 0 };
    }

    updateMotionDisplay(motionData) {
        document.getElementById('motionCoords').textContent = 
            `${Math.round(motionData.x)}, ${Math.round(motionData.y)}`;
        document.getElementById('motionIntensity').textContent = 
            `${Math.round(motionData.intensity * 100)}%`;

        this.updateModuleProgress('motionModule', motionData.intensity * 100);
    }

    calculateSoundDirection(audioData) {
        const left = audioData.slice(0, audioData.length / 2);
        const right = audioData.slice(audioData.length / 2);
        
        const leftAvg = this.getAverageLevel(left);
        const rightAvg = this.getAverageLevel(right);
        
        const angle = Math.atan2(rightAvg - leftAvg, (rightAvg + leftAvg) / 2) * (180 / Math.PI);
        
        document.getElementById('audioDirection').textContent = `${Math.round(angle)}°`;
        document.getElementById('soundLocation').textContent = 
            `${angle > 0 ? 'Right' : 'Left'} ${Math.abs(Math.round(angle))}°`;
    }

    async sendSensoryData() {
        try {
            const response = await fetch('process_sensory.php', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    audioLevel: this.audioData ? this.getAverageLevel(this.audioData) / 255 : 0,
                    motionData: {
                        x: document.getElementById('motionCoords').textContent,
                        intensity: parseFloat(document.getElementById('motionIntensity').textContent) / 100
                    },
                    soundDirection: document.getElementById('audioDirection').textContent
                })
            });

            if (response.ok) {
                const data = await response.json();
                this.updateModuleProgress('audioModule', data.analysis.soundTrend * 100);
                this.updateModuleProgress('videoModule', data.analysis.activityLevel * 100);
            }
        } catch (error) {
            console.error('Error sending sensory data:', error);
        }
    }

    updateModuleProgress(moduleId, percentage) {
        const progressBar = document.querySelector(`#${moduleId} .progress-bar`);
        if (progressBar) {
            progressBar.style.width = `${percentage}%`;
        }
    }

    start() {
        this.processSensoryData();
    }
}

document.addEventListener('DOMContentLoaded', () => {
    const sensoryInterface = new SensoryInterface();
    sensoryInterface.start();
});