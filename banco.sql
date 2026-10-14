CREATE DATABASE IF NOT EXISTS petcare;

USE petcare;

CREATE TABLE pets (
    id INT(11) NOT NULL AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    especie VARCHAR(50) NOT NULL,
    raca VARCHAR(100) NOT NULL,
    idade VARCHAR(30) NOT NULL,
    sexo ENUM('Masculino', 'Feminino') NOT NULL,
    peso VARCHAR(30) NOT NULL,
    porte ENUM('Mini', 'Pequeno', 'Médio', 'Grande', 'Gigante') NOT NULL,
    castrado ENUM('Sim', 'Não', 'Não informado') DEFAULT 'Não informado',
    alergia TEXT NULL,
    cirurgia TEXT NULL,
    condicao_especial TEXT NULL,
    criado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (id)
);  