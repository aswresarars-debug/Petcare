<?php
error_reporting(0);
ini_set('display_errors', 0);

header("Content-Type: application/json; charset=UTF-8");

include 'conexao.php';

$sql = "SELECT * FROM pets ORDER BY id DESC";
$resultado = $conexao->query($sql);

$pets = array();

if ($resultado->num_rows > 0) {
    while($row = $resultado->fetch_assoc()) {
        $pets[] = $row;
    }
}

echo json_encode(["sucesso" => true, "dados" => $pets]);

$conexao->close();
?>