#version 330 core

out vec4 FragColor;

in vec2 TexCoord;
in vec3 Normal;
in vec3 FragPos;//這個三角片片斷的位置

struct Material{//材質
	//vec3 ambient;
	sampler2D diffuse;
	sampler2D specular;
	sampler2D normal;

	float shininess;
};

struct Light{//phong model光源資訊
	vec3 position;
	
	vec3 ambient;
	vec3 diffuse;
	vec3 specular;
};




uniform vec3 viewPos;

uniform Material material;
uniform Light light;

void main()
{
	//ambient

	vec3 ambient = light.ambient * texture(material.diffuse,TexCoord).rgb;//將texture的RGB取出作成度量乘法後 只記錄他的RGB值 最後將受到這樣做法存起來的phong model三部分加總起來便是結果
	
	//diffuse
	vec3 norm = normalize(Normal);
    vec3 lightDir = normalize(light.position - FragPos);
    float diff = max(dot(norm, lightDir), 0.0);
    vec3 diffuse = light.diffuse * (diff * texture(material.diffuse,TexCoord).rgb);

	//specular

	vec3 viewDir = normalize(viewPos-FragPos);
	vec3 reflectDir = reflect(-lightDir, norm);  

    //float spec = pow(max(dot(viewDir, reflectDir), 0.0), 32);
	float spec = pow(max(dot(viewDir, reflectDir), 0.0), material.shininess);
	vec3 specular = light.specular * (spec * texture(material.specular,TexCoord).rgb);  //僅對需要高光的地方做specular運算
	
	
	FragColor = vec4((ambient + diffuse + specular),1.0);
	
}