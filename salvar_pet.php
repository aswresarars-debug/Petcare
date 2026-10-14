<?php
error_reporting(0);
ini_set('display_errors', 0);

header("Content-Type: application/json; charset=UTF-8");

include 'conexao.php';

$input = file_get_contents("php://input");
$data = json_decode($input, true);
 
if ($data && isset($data['nome']) && isset($data['especie'])) {
    $nome = $conexao->real_escape_string($data['nome']);
    $especie = $conexao->real_escape_string($data['especie']);
    $raca = $conexao->real_escape_string($data['raca'] ?? '');
    $idade = $conexao->real_escape_string($data['idade'] ?? '');
    $sexo = $conexao->real_escape_string($data['sexo'] ?? '');
    $peso = $conexao->real_escape_string($data['peso'] ?? '');
    $porte = $conexao->real_escape_string($data['porte'] ?? '');
    $castrado = $conexao->real_escape_string($data['castrado'] ?? '');
    $alergia = $conexao->real_escape_string($data['alergia'] ?? '');
    $cirurgia = $conexao->real_escape_string($data['cirurgia'] ?? '');
    $condicao_especial = $conexao->real_escape_string($data['condicao_especial'] ?? '');
    
    // Processamento da imagem em Base64
    $imagem_base64 = $data['imagem'] ?? '';
    $nome_arquivo_img = '';

    if (!empty($imagem_base64)) {
        $nome_arquivo_img = 'pet_' . time() . '.jpg';
        $caminho_pasta = 'uploads/';
        
        if (!file_exists($caminho_pasta)) {
            mkdir($caminho_pasta, 0777, true);
        }
        
        $caminho_completo = $caminho_pasta . $nome_arquivo_img;
        file_put_contents($caminho_completo, base64_decode($imagem_base64));
    }

    // ATENÇÃO: Verifique se no seu banco a coluna chama-se 'imagem' ou 'foto'. 
    // Na imagem anterior do phpMyAdmin estava 'foto', então vamos usar 'foto' na query:
    $sql = "INSERT INTO pets (nome, especie, raca, idade, sexo, peso, porte, castrado, alergia, cirurgia, condicao_especial, foto) 
            VALUES ('$nome', '$especie', '$raca', '$idade', '$sexo', '$peso', '$porte', '$castrado', '$alergia', '$cirurgia', '$condicao_especial', '$nome_arquivo_img')";

    if ($conexao->query($sql) === TRUE) {
        echo json_encode(["sucesso" => true, "mensagem" => "Pet cadastrado com sucesso!"]);
    } else {
        echo json_encode(["sucesso" => false, "mensagem" => "Erro no banco: " . $conexao->error]);
    }
} else {
    echo json_encode(["sucesso" => false, "mensagem" => "Dados incompletos!"]);
}

$conexao->close();
?>