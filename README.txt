 ================================================================
   GUIA COMPLETO - COMO USAR SCRIPTS NO ROBLOX
   Arquivo: BrookhavenRP.lua (ou qualquer .lua)
 ================================================================

 O QUE VOCÊ PRECISA:
 -------------------
 1. Um executor de scripts Roblox (ex: Synapse X, Fluxus, 
    Krnl, Script-Ware, Arceus X, etc.)
 2. O arquivo .lua que eu criei pra você
 3. O jogo Roblox aberto (no caso, Brookhaven RP)

 COMO EXECUTAR:
 --------------
 1. Abra o Roblox e entre no Brookhaven RP
 2. Abra seu executor (geralmente uma janela que aparece 
    por cima do jogo)
 3. No executor, clique em "Attach" ou "Inject" para 
    conectar ao Roblox
 4. Clique em "Open Script" e selecione o arquivo 
    "BrookhavenRP.lua"
 5. OU cole o código manualmente no editor do executor
 6. Clique em "Execute" (ou pressione F5/F8 dependendo 
    do executor)

 O QUE VAI ACONTECER:
 --------------------
 - Uma janela com o titulo "BROOKHAVEN RP" vai aparecer 
   no centro da tela
 - Se não aparecer, pressione F1 ou Insert no teclado
 - A janela tem abas no topo: Player, Seguir, Teleportes, 
   Misc, Config
 - Você pode arrastar a janela pelo cabeçalho azul escuro
 - Botão "─" minimiza pra barra, "X" fecha

 EXPLICACAO DAS ABAS E FUNCOES:
 -------------------------------

 === ABA: PLAYER ===
 
 [ESP - ON/OFF]
   Mostra uma caixa vermelha ao redor de cada jogador, 
   com nome, distancia e vida. A cor muda conforme a 
   vida (verde->amarelo->vermelho).

 [Invisivel - ON/OFF]
   Deixa seu personagem transparente (invisivel) para 
   outros jogadores. Sua ferramenta na mao continua 
   visivel.

 [Noclip - ON/OFF]
   Permite atravessar paredes, portas, objetos. Voce 
   anda normalmente mas passa por tudo. Desligue para 
   voltar ao normal.

 [Anti AFK - ON/OFF]
   Evita que o jogo te desconecte por inatividade. 
   Simula movimentos do mouse automaticamente.

 [Fly - ON/OFF]
   Ativa modo de voo. Use ESPACO para subir, SHIFT 
   (esquerdo) para descer. O mouse controla a direcao.

 WalkSpeed: [deslizante 10-120]
   Controla sua velocidade de movimento. Padrao: 16.
   Deslize para aumentar (correr mais rapido).

 JumpPower: [deslizante 10-200]
   Controla a altura do pulo.

 === ABA: SEGUIR ===
 
 Digite o nome de um jogador no campo e clique em 
 "SELECIONAR". O nome aparecera em verde se encontrado.
 
 [Seguir alvo]
   Ativa o跟随 automatico. Seu personagem segue o 
   jogador selecionado onde ele for.

 [Parar de seguir]
   Para o跟随 e limpa o alvo.

 === ABA: TELEPORTES ===
 
 Botoes com locais pre-definidos do Brookhaven:
   - Policia, Hospital, Escola, Supermercado, Banco,
     Praia, Flamingo, Castelo, Estacao, Prefeitura
   Clique em qualquer um para ir instantaneamente.

 [Teleportar para jogador]
   Digite o nome e clique. Voce vai aparecer ao lado 
   do jogador.

 [Ir para coordenadas]
   Digite X, Y, Z e clique para ir a um local exato.

 === ABA: MISC ===
 
 [Resetar personagem]
   Mata seu personagem e espera renascer. Mantem as 
   configuracoes ativas.

 [Godmode]
   Torna seu personagem imortal (experimental).

 [Infectar outros]
   Apenas para modo infectado.

 [Destruir GUI]
   Remove a janela completamente. Use F1 pra recriar
   (se o script suportar).

 === ABA: CONFIG ===
 
 [Salvar config]
   Salva suas configuracoes atuais (ESP, Invisivel, 
   etc.) para usar depois.

 [Carregar config]
   Restaura as configuracoes salvas.

 [Resetar config]
   Volta tudo ao normal.

 DICAS IMPORTANTES:
 ------------------
 - Use ESP + Invisivel juntos: voce ve todo mundo mas 
   ninguem te ve.
 - Fly + Noclip: voe atraves de qualquer lugar.
 - Se a janela nao aparecer, troque "PlayerGui" por 
   "CoreGui" na linha do ScreenGui.
 - Alguns executors bloqueiam certas funcoes. Se algo 
   nao funcionar, tente outro executor.
 - Nao abuse para nao ser banido. Use com moderacao.

 TECLAS DE ATALHO:
 -----------------
 F1 ou Insert  = Abrir/Fechar o menu
 (configuravel em Config > Keybind)

  DUVIDAS?
  --------
  Se algo nao funcionar:
  1. Verifique se o executor esta conectado (Attached)
  2. Veja se o console do executor mostrou "Carregado!"
  3. Tente F1 para abrir o menu
  4. Troque PlayerGui por CoreGui no codigo


================================================================
  SCRIPTS EXTRAS (executar SEPARADAMENTE)
================================================================

  === KILL.lua - 11 Metodos de Killing ===

  GUIA:
  - Abra o executor, execute KILL.lua (ou cole o codigo)
  - Pressione F1 para abrir o menu "KILL METHODS"
  - Digite o nome do jogador alvo no campo
  - Escolha um metodo de kill:
    1. Queda 300m  - teleporta o alvo a 300m de altura
    2. Veiculo     - esmaga com um veiculo
    3. Explosao    - explode o alvo
    4. Quebrar     - quebra todas as juntas do boneco
    5. Afogamento  - prende debaixo d'agua
    6. Fogo        - coloca fogo no alvo
    7. Loop Kill   - mata repetidamente (liga/desliga)
    8. Gravidade   - esmaga com gravidade alta
    9. Limbo       - teleporta pro vazio (Y=-500)
    10. Limpar     - remove o corpo do alvo
    11. Ferramenta - ataca com ferramenta equipada
  - [LIMPAR CORPOS] remove todos os corpos mortos do servidor
  - Loop Kill fica ativo ate desligar ou sair

  TECLA: F1 = Abrir/Fechar


  === SHOPPING_CART.lua - Carrinho de Compras Kidnap ===

  GUIA:
  - Execute SHOPPING_CART.lua
  - Pressione F1 para abrir o menu "CARRINHO KIDNAP"
  - Digite o nome do alvo
  - Botoes:
    [Procurar Carrinho] - acha um carrinho no mapa
    [Spawnar Carrinho]  - cria um carrinho novo
    [Capturar Alvo]    - puxa o alvo da cadeira/veiculo e prende
    [Chase & Capture]  - o carrinho persegue e captura sozinho
    [Levar pro Limbo]  - arrasta o carrinho+alvo pro vazio
    [Soltar Alvo]      - liberta o alvo
    [Destruir Carrinho] - remove o carrinho
  - O carrinho usa Weld para prender o alvo
  - Chase usa AlignPosition para seguir automaticamente

  TECLA: F1 = Abrir/Fechar


  === SOUND_SPAMMER.lua - Spam de Sons ===

  GUIA:
  - Execute SOUND_SPAMMER.lua
  - Pressione F1 para abrir o menu "SOUND SPAMMER"
  - Digite o nome do alvo para direcionar os sons
  - Escolha entre 18 sons pre-definidos:
    Sirene, Alarme, Buzina, Grito, Risada, Bass Boost,
    Earrape, Explosao, Telefone, Batida, Apito, Megafone,
    Tiro, Guitarra, Coracao, Chuva, Vento, Vibração
  - Volume ajustavel de 1 a 10
  - Modos:
    [Play Once]      - toca uma vez
    [Loop World]     - toca em loop no mundo (pra todo mundo ouvir)
    [Loop on Target] - toca em loop seguindo o alvo
  - Sounds personalizados: cole um Sound ID no campo
  - Cada som tem SoundEqualizerEffect e DistortionSoundEffect
  - Loop segue o jogador mesmo se ele se mover

  TECLA: F1 = Abrir/Fechar


  === PUXAR_CADEIRA.lua - Puxar de Cadeira/Veiculo ===

  GUIA:
  - Execute PUXAR_CADEIRA.lua
  - Pressione F1 para abrir o menu "PUXAR CADEIRA"
  - Digite o nome do alvo
  - Botoes:
    [Puxar da Cadeira]     - se o alvo estiver sentado, puxa ele
    [Puxar do Veiculo]     - se o alvo estiver num veiculo, puxa
    [Puxar + Jogar]        - puxa E joga 50m pra cima + 100m pra frente
    [Loop Pull ON/OFF]     - puxa automaticamente a cada tick
    [Radius Pull 20m]      - puxa TODOS os jogadores num raio de 20m
  - Detecta: hum.Sit, VehicleSeat.Occupant, seats
  - Loop Pull fica ativo ate desligar

  TECLA: F1 = Abrir/Fechar


  === ANNOY.lua - Annoy Toolbox (Incomodar) ===

  GUIA:
  - Execute ANNOY.lua
  - Pressione F1 para abrir o menu "ANNOY TOOLBOX"
  - Digite o nome do alvo para selecionar
  - Ferramentas disponiveis:

  MOVIMENTACAO:
    1. Empurrar (direita/esquerda) - da um empurrao
    2. Rodar ON/OFF - faz o alvo girar sem parar
    3. Sacudir ON/OFF - teleporta pra cima e baixo rapido
    4. Jogar pra cima - lancamento de 50m
    5. Puxar pra perto - puxa grudado em voce
    6. Trocar de lugar (swap) - troca posicao com o alvo

  PERTURBACAO:
    7. Cegar (flash) - tela branca na frente do rosto
    8. Prender (celula) - paredes invisiveis em volta
    9. Fake Lag ON/OFF - teleporta em circulo (parece lag)
    10. Inverter controles ON/OFF - gira 180 graus repetidamente
    11. Seguir colado ON/OFF - voce segue o alvo exatamente

  GERAL:
    [PARAR TUDO] - desliga todas as acoes ativas

  TECLA: F1 = Abrir/Fechar


================================================================
  NOTAS FINAIS - TODOS OS SCRIPTS
================================================================

  - Cada script e INDEPENDENTE. Execute apenas um por vez
    OU execute varios juntos (cada um com seu proprio F1)
  - Todos usam a mesma interface: tema escuro, azul, cantos
    arredondados, arrastavel pelo cabecalho
  - Todos salvam em PlayerGui (troque pra CoreGui se precisar)
  - Protip: Use KILL + SOUND_SPAMMER + ANNOY ao mesmo tempo
    para maximizar o caos!

  ================================================================
