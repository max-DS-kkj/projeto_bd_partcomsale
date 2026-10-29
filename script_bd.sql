CREATE TABLE cliente (
    id_cliente SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    telefone VARCHAR(15)
);

INSERT INTO cliente (nome, email, cpf, telefone) VALUES
('Mariah Juliana Melo', 'mariahjulianamelo@grupoblackout.com.br', '650.794.922-10', '(66) 99496-8783'),
('Emily Andrea Santos', 'emily.andrea.santos@santander.com.br', '705.588.631-75', '(85) 2827-0908'),
('Fernanda Clara Analu da Rosa', 'fernanda.clara.darosa@sp.gov.br', '333.444.555-66', '(66) 98381-1217');


CREATE TABLE endereco (
    id_endereco SERIAL PRIMARY KEY,
    logradouro VARCHAR(255) NOT NULL,
    numero VARCHAR(20) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    estado VARCHAR(2) NOT NULL,
    cep VARCHAR(9) NOT NULL,
    id_cliente INT NOT NULL,
    CONSTRAINT fk_endereco_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

INSERT INTO endereco (logradouro, numero, cidade, estado, cep, id_cliente) VALUES
('Rua das Flores', '123', 'São Paulo', 'SP', '51090-012', 1),
('Avenida Brasil', '456', 'Rio de Janeiro', 'RJ', '67364-096', 2),
('Rua dos Inconfidentes', '789', 'Belo Horizonte', 'MG', '95776-091', 3);

CREATE TABLE categoria (
    id_categoria SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT
);

INSERT INTO categoria (nome, descricao) VALUES
('Eletrônicos', 'Dispositivos eletrônicos em geral'),
('Móveis', 'Móveis para Quarto gamer e residência'),
('Vestuário', 'Roupas, calçados e acessórios');

CREATE TABLE fornecedor (
    id_fornecedor SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    cnpj VARCHAR(18) NOT NULL UNIQUE,
    contato VARCHAR(255)
);

INSERT INTO fornecedor (nome, cnpj, contato) VALUES
('Tech Distribuidora LTDA', '12.116.906/8267-90', 'vendas@techdistro.com'),
('Móveis Design S.A.', '98.765.929/5424-10', 'contato@moveisdesign.com'),
('Confecções Silva EIRELI', '45.656.912/8873-34', 'atendimento@confeccoessilva.com');

CREATE TABLE produto (
    id_produto SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    marca VARCHAR(255) NOT NULL,
    especificacoes_tecnicas TEXT,
    preco DECIMAL(10,2) NOT NULL,
    nota_avaliacao DECIMAL(3,2),
    id_categoria INT NOT NULL,
    id_fornecedor INT NOT NULL,
    CONSTRAINT fk_produto_categoria FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria),
    CONSTRAINT fk_produto_fornecedor FOREIGN KEY (id_fornecedor) REFERENCES fornecedor(id_fornecedor)
);

INSERT INTO produto (nome, marca, especificacoes_tecnicas, preco, nota_avaliacao, id_categoria, id_fornecedor) VALUES
('Galaxy S24 FE', 'Samsung', '256GB, 8GB RAM, Tela 6.7', 4299.00, 4.80, 1, 1),
('Cadeira Ergonômica Pro', 'Flexform', 'Ajuste de altura, apoio lombar, malha mesh', 850.00, 4.50, 2, 2),
('Camiseta Algodão Premium', 'Basics', '100% algodão penteado, cor preta, tamanho M', 79.90, 4.20, 3, 3);

CREATE TABLE compra (
    id_compra SERIAL PRIMARY KEY,
    data_compra TIMESTAMP,
    valor_total DECIMAL(10,2) NOT NULL,
    status VARCHAR(50),
    id_cliente INT NOT NULL,
    id_endereco INT NOT NULL,
    CONSTRAINT fk_compra_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    CONSTRAINT fk_compra_endereco FOREIGN KEY (id_endereco) REFERENCES endereco(id_endereco)
);

INSERT INTO compra (data_compra, valor_total, status, id_cliente, id_endereco) VALUES
('2026-05-01 10:30:00', 1999.90, 'Entregue', 1, 1),
('2026-09-12 14:15:00', 850.00, 'Em Transporte', 2, 2),
('2026-09-29 16:45:00', 159.80, 'Processando', 3, 3);

CREATE TABLE compra_produto (
    id_compra_produto SERIAL PRIMARY KEY,
    quantidade INT NOT NULL,
    valor_unitario DECIMAL(10,2) NOT NULL,
    id_compra INT NOT NULL,
    id_produto INT NOT NULL,
    CONSTRAINT fk_compra_produto_compra FOREIGN KEY (id_compra) REFERENCES compra(id_compra),
    CONSTRAINT fk_compra_produto_produto FOREIGN KEY (id_produto) REFERENCES produto(id_produto)
);

INSERT INTO compra_produto (quantidade, valor_unitario, id_compra, id_produto) VALUES
(1, 1999.90, 1, 1),
(1, 850.00, 2, 2),
(2, 79.90, 3, 3);

CREATE TABLE carrinho (
    id_carrinho SERIAL PRIMARY KEY,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    id_cliente INT NOT NULL,
    id_produto INT NOT NULL,
    CONSTRAINT fk_carrinho_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    CONSTRAINT fk_carrinho_produto FOREIGN KEY (id_produto) REFERENCES produto(id_produto)
);

INSERT INTO carrinho (quantidade, preco_unitario, id_cliente, id_produto) VALUES
(1, 79.90, 1, 3),
(2, 850.00, 2, 2),
(1, 1999.90, 3, 1)

CREATE TABLE pagamento (
    id_pagamento SERIAL PRIMARY KEY,
    forma_pagamento VARCHAR(50) NOT NULL,
    taxa_entrega DECIMAL(10,2),
    valor_pago DECIMAL(10,2) NOT NULL,
    status_pagamento VARCHAR(50),
    id_compra INT NOT NULL,
    CONSTRAINT fk_pagamento_compra FOREIGN KEY (id_compra) REFERENCES compra(id_compra)
);

INSERT INTO pagamento (forma_pagamento, taxa_entrega, valor_pago, status_pagamento, id_compra) VALUES
('Cartão de Crédito', 15.00, 2014.90, 'Aprovado', 1),
('PIX', 0.00, 850.00, 'Aprovado', 2),
('Boleto', 10.00, 169.80, 'Aguardando Pagamento', 3);

CREATE TABLE estoque (
    id_estoque SERIAL PRIMARY KEY,
    quantidade INT,
    localizacao_almacenar VARCHAR(100),
    id_produto INT NOT NULL,
    CONSTRAINT fk_estoque_produto FOREIGN KEY (id_produto) REFERENCES produto(id_produto)
);

INSERT INTO estoque (quantidade, localizacao_almacenar, id_produto) VALUES
(50, 'Corredor A - Prateleira 3', 1),
(20, 'Corredor B - Prateleira 1', 2),
(150, 'Corredor C - Prateleira 5', 3)
