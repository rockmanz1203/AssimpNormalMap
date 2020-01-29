#version 330 core
out vec4 FragColor;

in vec2 TexCoords;
in vec3 FragPos;
in vec3 Normal;

in VS_OUT{
	vec3 FragPos;
	vec2 TexCoords;
	vec3 TangentLightPos;
	vec3 TangentViewPos;
	vec3 TangentFragPos;
} fs_in;


uniform sampler2D texture_diffuse1;//各種貼圖都active好了也送到shader中了 如果你有藥用再來這邊宣告來使用就可以
uniform sampler2D texture_specular1;
uniform sampler2D texture_specular2;

uniform sampler2D texture_normal1;


uniform sampler2D TEST;
uniform vec3 lightPos;
uniform vec3 viewPos;

uniform int shiness;
uniform vec3 Ka;
uniform vec3 Kd;
uniform vec3 Ks;

/*struct Material {
	sampler2D diffuse;
	sampler2D specular;
	float shininess;
};*/

//Material material;

void main()
{
	//vec3 norm = normalize(Normal);
	vec3 normal = texture(texture_normal1, fs_in.TexCoords).rgb;
	normal = normalize(normal*2.0 - 1.0);


	vec3 lightColor = vec3(1.0,1.0,1.0);
	
	float ambientStrengh = 0.1;
	vec3 ambient = ambientStrengh * lightColor  * texture(texture_diffuse1, TexCoords).rgb;// phong打環境光的得到的顏色


	vec3 diffusecolor = texture(texture_diffuse1, fs_in.TexCoords).rgb;

	vec3 lightDir = normalize(fs_in.TangentLightPos - fs_in.TangentFragPos);
	float diff = max(dot(normal, lightDir), 0.0);
	vec3 diffuse = Kd * diff * lightColor * diffusecolor;// phong打漫反射光的得到的顏色

	vec3 viewDir = normalize(fs_in.TangentViewPos - fs_in.TangentFragPos);
	vec3 reflectDir = reflect(-lightDir, normal);
	vec3 halfwayDir = normalize(lightDir + viewDir);
	float spec = pow(max(dot(normal, halfwayDir), 0.0), 32.0);

	vec3 specular = vec3(0.2) * spec;

	vec3 result = (ambient + diffuse + specular);

	FragColor = vec4(result, 1.0);
}