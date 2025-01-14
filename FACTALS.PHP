<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Advanced Fractal Gallery</title>
    <style>
        body {
            margin: 0;
            font-family: system-ui, -apple-system, sans-serif;
            background: #0a0a0a;
            color: #fff;
                    },
            {
                id: 'celtic',
                name: 'Celtic Fractal',
                description: 'A variation using absolute values and complex arithmetic, creating knot-like patterns.',
                equation: 'z = |Re(z^2)| + i|Im(z^2)| + c',
                fragmentShader: `
                    uniform float time;
                    uniform vec2 resolution;
                    uniform float param1;
                    uniform float param2;
                    uniform float param3;
                    uniform float param4;
                    varying vec2 vUv;

                    vec2 iterate(vec2 z, vec2 c) {
                        vec2 z2 = vec2(z.x * z.x - z.y * z.y, 2.0 * z.x * z.y);
                        return vec2(abs(z2.x), abs(z2.y)) + c;
                    }

                    void main() {
                        vec2 p = (vUv * 2.0 - 1.0) * vec2(resolution.x/resolution.y, 1.0);
                        vec2 z = p;
                        vec2 c = vec2(param1, param2);
                        
                        float i;
                        for(i = 0.0; i < param3; i++) {
                            z = iterate(z, c);
                            if(length(z) > param4) break;
                        }
                        
                        float h = i / param3;
                        vec3 color = 0.5 + 0.5 * cos(h * 15.0 + vec3(0.0, 0.6, 1.0));
                        gl_FragColor = vec4(color * (1.0 - h), 1.0);
                    }
                `,
                params: {
                    param1: { name: 'Real Offset', default: -0.4, min: -2, max: 2 },
                    param2: { name: 'Imag Offset', default: 0.6, min: -2, max: 2 },
                    param3: { name: 'Max Iterations', default: 100, min: 1, max: 200 },
                    param4: { name: 'Escape Radius', default: 4, min: 1, max: 10 }
                }
            },
            {
                id: 'biomorph',
                name: 'Biomorph Fractal',
                description: 'Creates organic-looking shapes using complex dynamics and symmetry breaking.',
                equation: 'z = z^3 / (1 + |z|^2) + c',
                fragmentShader: `
                    uniform float time;
                    uniform vec2 resolution;
                    uniform float param1;
                    uniform float param2;
                    uniform float param3;
                    uniform float param4;
                    varying vec2 vUv;

                    vec2 cmul(vec2 a, vec2 b) {
                        return vec2(a.x * b.x - a.y * b.y, a.x * b.y + a.y * b.x);
                    }

                    vec2 iterate(vec2 z, vec2 c) {
                        vec2 z2 = cmul(z, z);
                        vec2 z3 = cmul(z2, z);
                        float denom = 1.0 + dot(z, z);
                        return vec2(z3.x / denom, z3.y / denom) + c;
                    }

                    void main() {
                        vec2 p = (vUv * 2.0 - 1.0) * vec2(resolution.x/resolution.y, 1.0) * 1.5;
                        vec2 z = p;
                        vec2 c = vec2(param1, param2);
                        
                        float i;
                        for(i = 0.0; i < param3; i++) {
                            z = iterate(z, c);
                            if(abs(z.x) > param4 || abs(z.y) > param4) break;
                        }
                        
                        float h = i / param3;
                        vec3 color = vec3(
                            0.5 + 0.5 * sin(h * 8.0),
                            0.5 + 0.5 * sin(h * 12.0 + 2.0),
                            0.5 + 0.5 * sin(h * 16.0 + 4.0)
                        );
                        gl_FragColor = vec4(color, 1.0);
                    }
                `,
                params: {
                    param1: { name: 'Real Part', default: -0.2, min: -2, max: 2 },
                    param2: { name: 'Imag Part', default: 0.8, min: -2, max: 2 },
                    param3: { name: 'Max Iterations', default: 50, min: 1, max: 100 },
                    param4: { name: 'Boundary', default: 2, min: 1, max: 5 }
                }
            },
            {
                id: 'magnet',
                name: 'Magnet Set',
                description: 'Based on renormalization of rational functions, creating magnetic field-like patterns.',
                equation: 'z = ((z^2 + c - 1)/(2z + c - 2))^2',
                fragmentShader: `
                    uniform float time;
                    uniform vec2 resolution;
                    uniform float param1;
                    uniform float param2;
                    uniform float param3;
                    uniform float param4;
                    varying vec2 vUv;

                    vec2 cmul(vec2 a, vec2 b) {
                        return vec2(a.x * b.x - a.y * b.y, a.x * b.y + a.y * b.x);
                    }

                    vec2 cdiv(vec2 a, vec2 b) {
                        float denom = dot(b, b);
                        return vec2(dot(a, b) / denom, (a.y * b.x - a.x * b.y) / denom);
                    }

                    vec2 iterate(vec2 z, vec2 c) {
                        vec2 num = cmul(z, z) + c - vec2(1.0, 0.0);
                        vec2 den = 2.0 * z + c - vec2(2.0, 0.0);
                        vec2 frac = cdiv(num, den);
                        return cmul(frac, frac);
                    }

                    void main() {
                        vec2 p = (vUv * 2.0 - 1.0) * vec2(resolution.x/resolution.y, 1.0) * param4;
                        vec2 z = p;
                        vec2 c = vec2(param1, param2);
                        
                        float i;
                        for(i = 0.0; i < param3; i++) {
                            z = iterate(z, c);
                            if(length(z) > 4.0) break;
                        }
                        
                        float h = i / param3;
                        vec3 color = 0.5 + 0.5 * cos(h * 20.0 + vec3(0.0, 2.0, 4.0));
                        gl_FragColor = vec4(color, 1.0);
                    }
                `,
                params: {
                    param1: { name: 'Real Part', default: 0.0, min: -2, max: 2 },
                    param2: { name: 'Imag Part', default: 1.0, min: -2, max: 2 },
                    param3: { name: 'Max Iterations', default: 30, min: 1, max: 100 },
                    param4: { name: 'Zoom', default: 1.0, min: 0.1, max: 4 }
                }
            },
            {
                id: 'lambda',
                name: 'Lambda Fractal',
                description: 'Based on exponential functions, creating spiral and web-like patterns.',
                equation: 'z = λ * z * (1 - z)',
                fragmentShader: `
                    uniform float time;
                    uniform vec2 resolution;
                    uniform float param1;
                    uniform float param2;
                    uniform float param3;
                    uniform float param4;
                    varying vec2 vUv;

                    vec2 cmul(vec2 a, vec2 b) {
                        return vec2(a.x * b.x - a.y * b.y, a.x * b.y + a.y * b.x);
                    }

                    vec2 iterate(vec2 z, vec2 lambda) {
                        vec2 one = vec2(1.0, 0.0);
                        return cmul(lambda, cmul(z, one - z));
                    }

                    void main() {
                        vec2 p = (vUv * 2.0 - 1.0) * vec2(resolution.x/resolution.y, 1.0) * param4;
                        vec2 z = p;
                        vec2 lambda = vec2(param1, param2);
                        
                        float i;
                        for(i = 0.0; i < param3; i++) {
                            z = iterate(z, lambda);
                            if(length(z) > 2.0) break;
                        }
                        
                        float h = i / param3;
                        vec3 color = vec3(
                            0.5 * sin(h * 10.0) + 0.5,
                            0.5 * sin(h * 15.0 + 2.0) + 0.5,
                            0.5 * sin(h * 20.0 + 4.0) + 0.5
                        );
                        gl_FragColor = vec4(color, 1.0);
                    }
                `,
                params: {
                    param1: { name: 'Lambda Real', default: -0.4, min: -2, max: 2 },
                    param2: { name: 'Lambda Imag', default: 0.6, min: -2, max: 2 },
                    param3: { name: 'Max Iterations', default: 80, min: 1, max: 200 },
                    param4: { name: 'Zoom', default: 1.5, min: 0.1, max: 4 }
                }
            },
            {
                id: 'collatz',
                name: 'Collatz Fractal',
                description: 'Based on the complex extension of the Collatz conjecture, creating intricate spiral patterns.',
                equation: '(1 + 4z) / 2  or  (3z + 1) / 2',
                fragmentShader: `
                    uniform float time;
                    uniform vec2 resolution;
                    uniform float param1;
                    uniform float param2;
                    uniform float param3;
                    uniform float param4;
                    varying vec2 vUv;

                    vec2 cmul(vec2 a, vec2 b) {
                        return vec2(a.x * b.x - a.y * b.y, a.x * b.y + a.y * b.x);
                    }

                    vec2 iterate(vec2 z) {
                        vec2 z3 = cmul(z, vec2(3.0, 0.0));
                        z3 = z3 + vec2(1.0, 0.0);
                        return z3 * 0.5;
                    }

                    void main() {
                        vec2 p = (vUv * 2.0 - 1.0) * vec2(resolution.x/resolution.y, 1.0);
                        vec2 z = p * param4 + vec2(param1, param2);
                        
                        float i;
                        for(i = 0.0; i < param3; i++) {
                            z = iterate(z);
                            if(length(z) > 2.0) break;
                        }
                        
                        float h = i / param3;
                        vec3 color = 0.5 + 0.5 * cos(h * 12.0 + vec3(0.0, 1.0, 2.0));
                        gl_FragColor = vec4(color, 1.0);
                    }
                `,
                params: {
                    param1: { name: 'X Offset', default: 0.0, min: -2, max: 2 },
                    param2: { name: 'Y Offset', default: 0.0, min: -2, max: 2 },
                    param3: { name: 'Max Iterations', default: 50, min: 1, max: 100 },
                    param4: { name: 'Zoom', default: 2.0, min: 0.1, max: 5 }
                }
            }
        .gallery {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(500px, 1fr));
            gap: 20px;
            padding: 20px;
            max-width: 2000px;
            margin: 0 auto;
        }
        .fractal-card {
            background: #1a1a1a;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 8px rgba(0,0,0,0.5);
        }
        .canvas-container {
            width: 100%;
            height: 400px;
            position: relative;
        }
        .fractal-info {
            padding: 20px;
        }
        h2 {
            margin: 0 0 10px 0;
            color: #4a9eff;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .description {
            color: #cccccc;
            margin-bottom: 15px;
            line-height: 1.5;
        }
        .controls {
            background: #0f0f0f;
            padding: 15px;
            border-radius: 5px;
            margin-top: 15px;
        }
        .editor {
            width: 100%;
            height: 100px;
            background: #000;
            color: #fff;
            font-family: monospace;
            padding: 10px;
            border: 1px solid #333;
            border-radius: 4px;
            margin: 10px 0;
            resize: vertical;
        }
        .shader-select {
            width: 100%;
            padding: 8px;
            background: #000;
            color: #fff;
            border: 1px solid #333;
            border-radius: 4px;
            margin-bottom: 10px;
        }
        .params {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 10px;
            margin-top: 10px;
        }
        .param-group {
            display: flex;
            flex-direction: column;
        }
        .param-group label {
            color: #4a9eff;
            margin-bottom: 5px;
        }
        .param-group input {
            width: 100%;
        }
        button {
            background: #4a9eff;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
            font-weight: bold;
            margin-top: 10px;
        }
        button:hover {
            background: #2a7fff;
        }
    </style>
</head>
<body>
    <div class="gallery" id="gallery"></div>

    <script type="importmap">
    {
        "imports": {
            "three": "https://cdnjs.cloudflare.com/ajax/libs/three.js/0.162.0/three.module.js"
        }
    }
    </script>

    <script type="module">
        import * as THREE from 'three';

        const defaultFragmentShader = `
            uniform float time;
            uniform vec2 resolution;
            uniform vec3 cameraPos;
            uniform float param1;
            uniform float param2;
            uniform float param3;
            uniform float param4;

            varying vec2 vUv;

            // You can modify this function to change the fractal
            vec2 iterate(vec2 z, vec2 c) {
                return vec2(z.x * z.x - z.y * z.y, 2.0 * z.x * z.y) + c;
            }

            void main() {
                vec2 p = (vUv * 2.0 - 1.0) * vec2(resolution.x/resolution.y, 1.0);
                vec2 z = p;
                vec2 c = vec2(param1, param2);
                
                float i;
                for(i = 0.0; i < param3; i++) {
                    z = iterate(z, c);
                    if(length(z) > param4) break;
                }
                
                float h = i / param3;
                vec3 color = 0.5 + 0.5 * cos(3.0 + h * 6.28 + vec3(0.0, 0.6, 1.0));
                gl_FragColor = vec4(color, 1.0);
            }
        `;

        const fractals = [
            {
                id: 'mandelbrot',
                name: 'Mandelbrot Set',
                description: 'The classic Mandelbrot set with customizable iteration formula.',
                equation: 'z = z^2 + c',
                fragmentShader: defaultFragmentShader,
                params: {
                    param1: { name: 'Real Offset', default: -0.5, min: -2, max: 2 },
                    param2: { name: 'Imag Offset', default: 0, min: -2, max: 2 },
                    param3: { name: 'Max Iterations', default: 100, min: 1, max: 200 },
                    param4: { name: 'Escape Radius', default: 2, min: 1, max: 10 }
                }
            },
            {
                id: 'julia',
                name: 'Julia Set',
                description: 'Dynamic Julia set with adjustable parameters.',
                equation: 'z = z^2 + c, c = constant',
                fragmentShader: defaultFragmentShader,
                params: {
                    param1: { name: 'Julia Real', default: 0.285, min: -2, max: 2 },
                    param2: { name: 'Julia Imag', default: 0.01, min: -2, max: 2 },
                    param3: { name: 'Max Iterations', default: 100, min: 1, max: 200 },
                    param4: { name: 'Escape Radius', default: 2, min: 1, max: 10 }
                }
            },
            {
                id: 'burning-ship',
                name: 'Burning Ship Fractal',
                description: 'A variation of the Mandelbrot set using absolute values, creating a distinctive flame-like pattern.',
                equation: 'z = (|Re(z)| + i|Im(z)|)^2 + c',
                fragmentShader: `
                    uniform float time;
                    uniform vec2 resolution;
                    uniform float param1;
                    uniform float param2;
                    uniform float param3;
                    uniform float param4;
                    varying vec2 vUv;

                    vec2 iterate(vec2 z, vec2 c) {
                        vec2 a = abs(z);
                        return vec2(a.x * a.x - a.y * a.y, 2.0 * a.x * a.y) + c;
                    }

                    void main() {
                        vec2 p = (vUv * 2.0 - 1.0) * vec2(resolution.x/resolution.y, 1.0);
                        vec2 z = p;
                        vec2 c = vec2(param1, param2);
                        
                        float i;
                        for(i = 0.0; i < param3; i++) {
                            z = iterate(z, c);
                            if(length(z) > param4) break;
                        }
                        
                        float h = i / param3;
                        vec3 color = 0.5 + 0.5 * cos(3.0 + h * 6.28 + vec3(0.0, 0.6, 1.0));
                        gl_FragColor = vec4(color, 1.0);
                    }
                `,
                params: {
                    param1: { name: 'X Offset', default: -0.4, min: -2, max: 2 },
                    param2: { name: 'Y Offset', default: -0.5, min: -2, max: 2 },
                    param3: { name: 'Max Iterations', default: 100, min: 1, max: 200 },
                    param4: { name: 'Escape Radius', default: 4, min: 1, max: 10 }
                }
            },
            {
                id: 'tricorn',
                name: 'Tricorn Fractal',
                description: 'Also known as the Mandelbar set, using complex conjugate in iteration.',
                equation: 'z = conj(z)^2 + c',
                fragmentShader: `
                    uniform float time;
                    uniform vec2 resolution;
                    uniform float param1;
                    uniform float param2;
                    uniform float param3;
                    uniform float param4;
                    varying vec2 vUv;

                    vec2 iterate(vec2 z, vec2 c) {
                        return vec2(z.x * z.x - z.y * z.y, -2.0 * z.x * z.y) + c;
                    }

                    void main() {
                        vec2 p = (vUv * 2.0 - 1.0) * vec2(resolution.x/resolution.y, 1.0);
                        vec2 z = p;
                        vec2 c = vec2(param1, param2);
                        
                        float i;
                        for(i = 0.0; i < param3; i++) {
                            z = iterate(z, c);
                            if(length(z) > param4) break;
                        }
                        
                        float h = i / param3;
                        vec3 color = vec3(
                            0.5 * sin(h * 20.0) + 0.5,
                            0.5 * sin(h * 15.0 + 2.0) + 0.5,
                            0.5 * sin(h * 10.0 + 4.0) + 0.5
                        );
                        gl_FragColor = vec4(color, 1.0);
                    }
                `,
                params: {
                    param1: { name: 'Real Part', default: 0.0, min: -2, max: 2 },
                    param2: { name: 'Imag Part', default: 0.0, min: -2, max: 2 },
                    param3: { name: 'Max Iterations', default: 100, min: 1, max: 200 },
                    param4: { name: 'Escape Value', default: 2, min: 1, max: 10 }
                }
            },
            {
                id: 'nova',
                name: 'Nova Fractal',
                description: 'A fractal based on Newton\'s method for finding roots of complex polynomials.',
                equation: 'z = z - (z^3 - 1)/(3z^2)',
                fragmentShader: `
                    uniform float time;
                    uniform vec2 resolution;
                    uniform float param1;
                    uniform float param2;
                    uniform float param3;
                    uniform float param4;
                    varying vec2 vUv;

                    vec2 cmul(vec2 a, vec2 b) {
                        return vec2(a.x * b.x - a.y * b.y, a.x * b.y + a.y * b.x);
                    }

                    vec2 cdiv(vec2 a, vec2 b) {
                        float denom = b.x * b.x + b.y * b.y;
                        return vec2(
                            (a.x * b.x + a.y * b.y) / denom,
                            (a.y * b.x - a.x * b.y) / denom
                        );
                    }

                    vec2 iterate(vec2 z) {
                        vec2 z2 = cmul(z, z);
                        vec2 z3 = cmul(z2, z);
                        vec2 top = z3 - vec2(1.0, 0.0);
                        vec2 bottom = 3.0 * z2;
                        return z - cdiv(top, bottom);
                    }

                    void main() {
                        vec2 p = (vUv * 2.0 - 1.0) * vec2(resolution.x/resolution.y, 1.0) * param4;
                        vec2 z = p;
                        
                        float i;
                        for(i = 0.0; i < param3; i++) {
                            z = iterate(z);
                            if(length(z - vec2(1.0, 0.0)) < 0.001) break;
                            if(length(z - vec2(-0.5, 0.866)) < 0.001) break;
                            if(length(z - vec2(-0.5, -0.866)) < 0.001) break;
                        }
                        
                        float h = i / param3;
                        vec3 color = 0.5 + 0.5 * cos(param1 + h * param2 + vec3(0.0, 2.0, 4.0));
                        gl_FragColor = vec4(color, 1.0);
                    }
                `,
                params: {
                    param1: { name: 'Color Phase', default: 0.0, min: 0, max: 6.28 },
                    param2: { name: 'Color Frequency', default: 15.0, min: 1, max: 30 },
                    param3: { name: 'Max Iterations', default: 50, min: 1, max: 100 },
                    param4: { name: 'Zoom', default: 1.5, min: 0.1, max: 5 }
                }
            },
            {
                id: 'phoenix',
                name: 'Phoenix Fractal',
                description: 'A complex fractal that includes the previous iteration in its formula.',
                equation: 'z_new = z^2 + p*z_prev + c',
                fragmentShader: `
                    uniform float time;
                    uniform vec2 resolution;
                    uniform float param1;
                    uniform float param2;
                    uniform float param3;
                    uniform float param4;
                    varying vec2 vUv;

                    vec2 iterate(vec2 z, vec2 prev, vec2 c, float p) {
                        return vec2(
                            z.x * z.x - z.y * z.y + p * prev.x + c.x,
                            2.0 * z.x * z.y + p * prev.y + c.y
                        );
                    }

                    void main() {
                        vec2 p = (vUv * 2.0 - 1.0) * vec2(resolution.x/resolution.y, 1.0);
                        vec2 z = p;
                        vec2 prev = z;
                        vec2 c = vec2(param1, param2);
                        
                        float i;
                        for(i = 0.0; i < param3; i++) {
                            vec2 temp = z;
                            z = iterate(z, prev, c, param4);
                            prev = temp;
                            if(length(z) > 4.0) break;
                        }
                        
                        float h = i / param3;
                        vec3 color = vec3(
                            0.5 + 0.5 * sin(h * 6.28),
                            0.5 + 0.5 * sin(h * 6.28 + 2.09),
                            0.5 + 0.5 * sin(h * 6.28 + 4.18)
                        );
                        gl_FragColor = vec4(color, 1.0);
                    }
                `,
                params: {
                    param1: { name: 'Real Part', default: -0.5, min: -2, max: 2 },
                    param2: { name: 'Imag Part', default: 0.0, min: -2, max: 2 },
                    param3: { name: 'Max Iterations', default: 100, min: 1, max: 200 },
                    param4: { name: 'Previous Weight', default: 0.5, min: -2, max: 2 }
                }
            }
            // Add more fractals here
        ];

        fractals.forEach(fractal => {
            const card = document.createElement('div');
            card.className = 'fractal-card';
            
            const canvasContainer = document.createElement('div');
            canvasContainer.className = 'canvas-container';
            
            const info = document.createElement('div');
            info.className = 'fractal-info';
            info.innerHTML = `
                <h2>${fractal.name}</h2>
                <p class="description">${fractal.description}</p>
                <div class="controls">
                    <textarea class="editor" spellcheck="false">${fractal.equation}</textarea>
                    
                    <div class="params">
                        ${Object.entries(fractal.params).map(([key, param]) => `
                            <div class="param-group">
                                <label>${param.name}: <span id="${fractal.id}-${key}-value">${param.default}</span></label>
                                <input type="range" 
                                    id="${fractal.id}-${key}"
                                    min="${param.min}"
                                    max="${param.max}"
                                    step="0.01"
                                    value="${param.default}">
                            </div>
                        `).join('')}
                    </div>
                    
                    <button id="${fractal.id}-update">Update Fractal</button>
                </div>
            `;
            
            card.appendChild(canvasContainer);
            card.appendChild(info);
            document.getElementById('gallery').appendChild(card);

            // Three.js setup
            const scene = new THREE.Scene();
            const camera = new THREE.OrthographicCamera(-1, 1, 1, -1, 0.1, 10);
            const renderer = new THREE.WebGLRenderer({ antialias: true });
            renderer.setSize(canvasContainer.clientWidth, canvasContainer.clientHeight);
            canvasContainer.appendChild(renderer.domElement);

            // Create shader material
            const uniforms = {
                time: { value: 0 },
                resolution: { value: new THREE.Vector2(canvasContainer.clientWidth, canvasContainer.clientHeight) },
                cameraPos: { value: new THREE.Vector3() },
                param1: { value: fractal.params.param1.default },
                param2: { value: fractal.params.param2.default },
                param3: { value: fractal.params.param3.default },
                param4: { value: fractal.params.param4.default }
            };

            const material = new THREE.ShaderMaterial({
                uniforms: uniforms,
                fragmentShader: fractal.fragmentShader,
                vertexShader: `
                    varying vec2 vUv;
                    void main() {
                        vUv = uv;
                        gl_Position = vec4(position, 1.0);
                    }
                `
            });

            // Create plane
            const geometry = new THREE.PlaneGeometry(2, 2);
            const mesh = new THREE.Mesh(geometry, material);
            scene.add(mesh);
            camera.position.z = 1;

            // Animation
            function animate(time) {
                requestAnimationFrame(animate);
                uniforms.time.value = time * 0.001;
                renderer.render(scene, camera);
            }
            animate(0);

            // Event listeners for parameters
            Object.entries(fractal.params).forEach(([key, param]) => {
                const input = document.getElementById(`${fractal.id}-${key}`);
                const value = document.getElementById(`${fractal.id}-${key}-value`);
                input.addEventListener('input', (e) => {
                    const val = parseFloat(e.target.value);
                    uniforms[key].value = val;
                    value.textContent = val.toFixed(2);
                });
            });

            // Window resize handling
            window.addEventListener('resize', () => {
                const width = canvasContainer.clientWidth;
                const height = canvasContainer.clientHeight;
                renderer.setSize(width, height);
                uniforms.resolution.value.set(width, height);
            });
        });
    </script>
</body>
</html>