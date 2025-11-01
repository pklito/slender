#version 330

#moj_import <shader_selector:marker_settings.glsl>
#moj_import <shader_selector:utils.glsl>

uniform sampler2D MainSampler;
uniform sampler2D DataSampler;
uniform sampler2D BlurSampler;

uniform vec2 OutSize;
uniform float GameTime;

in vec2 texCoord;

out vec4 fragColor;

float readChannel(int channel) {
    return decodeColor(texelFetch(DataSampler, ivec2(4, channel), 0));
}

float random (vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

void main() {

    // Apply rotation effect
    // Read rotation amount
    float rotationAmount = readChannel(SHADER_F5_CHANNEL);

    vec2 uv = texCoord;
    fragColor = texture(MainSampler, uv);
    if(rotationAmount > 0.9) {
        fragColor = mix(fragColor, vec4(1,0,0,1), rotationAmount/2);
    }

    // Apply greyscale effect
    // Get full greyscale color
    vec3 greyscale =  vec3(random(vec2(floor(uv.x*500)/500, floor(uv.y*500)/500)*(1 + GameTime)));
    
    // Apply greyscale color
    float greyscaleAmount = readChannel(SHADER_NOISE_CHANNEL)/1.0;
    fragColor.rgb = mix(fragColor.rgb, greyscale, greyscaleAmount);

//#define DEBUG
#ifdef DEBUG
    // Show data sampler on screen
    if (texCoord.x < .25 && texCoord.y < .25) {
        uv = texCoord * 4.0;
        vec4 col = texture(DataSampler, uv);
        if (uv.x > 1./5.)
            col = vec4(vec3(fract(decodeColor(col))), 1.0);
        fragColor = col;
    }
#endif
}