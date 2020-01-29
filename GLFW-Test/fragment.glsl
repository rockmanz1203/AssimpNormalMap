#version 330 core

out vec4 FragColor;

in vec2 TexCoord;
in vec3 Normal;
in vec3 FragPos;//�o�ӤT�������_����m

struct Material{//����
	//vec3 ambient;
	sampler2D diffuse;
	sampler2D specular;
	sampler2D normal;

	float shininess;
};

struct Light{//phong model������T
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

	vec3 ambient = light.ambient * texture(material.diffuse,TexCoord).rgb;//�Ntexture��RGB���X�@���׶q���k�� �u�O���L��RGB�� �̫�N����o�˰��k�s�_�Ӫ�phong model�T�����[�`�_�ӫK�O���G
	
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
	vec3 specular = light.specular * (spec * texture(material.specular,TexCoord).rgb);  //�ȹ�ݭn�������a�谵specular�B��
	
	
	FragColor = vec4((ambient + diffuse + specular),1.0);
	
}