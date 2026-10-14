<?php
$host = "localhost:3308"; // Ajuste a porta se necessário
$usuario = "root";
$senha = "";
$banco = "petcare";

$conexao = new mysqli($host, $usuario, $senha, $banco);

if ($conexao->connect_error) {
    die("Erro de conexão: " . $conexao->connect_error);
}
$conexao->set_charset("utf8");
?>