<?php
error_reporting(0);
ini_set('display_errors', 0);

header("Content-Type: application/json; charset=UTF-8");

include 'conexao.php';

$input = file_get_contents("php://input");
$data = json_decode($input, true);

if ($data && isset($data['id'])) {
    $id = intval($data['id']);

    $sql = "DELETE FROM pets WHERE id = $id";

    if ($conexao->query($sql) === TRUE) {
        echo json_encode(["sucesso" => true, "mensagem" => "Pet excluído com sucesso!"]);
    } else {
        echo json_encode(["sucesso" => false, "mensagem" => "Erro ao excluir: " . $conexao->error]);
    }
} else {
    echo json_encode(["sucesso" => false, "mensagem" => "ID inválido ou não fornecido!"]);
}

$conexao->close();
?>