%Guilherme Vilar Balduino 743546
%Roberto Yamamoto 743594

%Ambiente 1: solucao_bl([9,0,0,3,[[6,1],[6,4],[2,3]],[[5,4],[4,2],[7,1],[4,0]],[[1],[8]],[[4,4]],[[3,0]],[[10]],[[5]],no_fim],X).
%Para rodar o codigo: solucao_bl([situacao inicial],X).

%(X,Y) posição do aspirador 
%(Z,W) posição atualizada do aspirador
%S indica o número de sujeiras que o aspirador possui
%M indica o novo número de sujeiras que o aspirador possui
%F indica o número de sujeiras que faltam no cenário
%K indica o número atualizado de sujeiras que faltam no cenário
%L, L1 e L2 indicam a lista de posições das sujeiras restantes
%P indica lista de paredes
%E indica colunas onde há elevadores
%G indica a posição da(s) lixeira(s)
%D indica a localização do dock
%LimX e LimY indica os limites (X,Y) do ambiente

%inicial([9,0,0,3,[[6,1],[6,4],[2,3]],P,E,G,D,LimX,LimY,no_fim]).
meta([_,_,_,_,_,_,_,_,_,_,_,fim]).
meta([_,_,_,_,_,_,_,_,_,_,_,fim]) :- s([X,Y,S,F,[],P,E,G,D,LimX,LimY,no_fim],[X,Y,S,F,[],P,E,G,D,LimX,LimY,fim]).

%Fim do programa
s([X,Y,S,F,[],P,E,G,D,LimX,LimY,no_fim],[X,Y,S,F,[],P,E,G,D,LimX,LimY,fim]):- S == 0, F == 0, pertence([X,Y],D), write('Fim '), writeln([X,Y,S,F,[],fim]), write('\n'), !.

%pega lixo
s([X,Y,S,F,L1,P,E,G,D,LimX,LimY,no_fim],[X,Y,M,K,L2,P,E,G,D,LimX,LimY,no_fim]):- M is S+1, K is F-1, S < 2, F > 0, pertence([X,Y],L1), retirar_elemento([X,Y],L1,L2),
write('=> Pegou o lixo\nAntes: '), writeln([X,Y,S,F,L1]), write('Depois: '), writeln([X,Y,M,K,L2]), write('\n'), !.

%joga lixo
s([X,Y,S,F,L,P,E,G,D,LimX,LimY,no_fim],[X,Y,M,F,L,P,E,G,D,LimX,LimY,no_fim]):- S > 0, M is 0, pertence([X,Y],G),
write('=> Jogou o lixo fora\nAntes: '), writeln([X,Y,S,F,L]), write('Depois: '), writeln([X,Y,M,F,L]), write('\n'), !.

s([X,Y,S,F,L,P,E,G,D,LimX,LimY,no_fim],[W,Y,S,F,L,P,E,G,D,LimX,LimY,no_fim]) :- W is X+1, not(pertence([W],LimX)), not(pertence([W,Y],P)).  %direita
s([X,Y,S,F,L,P,E,G,D,LimX,LimY,no_fim],[W,Y,S,F,L,P,E,G,D,LimX,LimY,no_fim]) :- W is X-1, W >= 0, not(pertence([W,Y],P)).  %esquerda

s([X,Y,S,F,L,P,E,G,D,LimX,LimY,no_fim],[X,Z,S,F,L,P,E,G,D,LimX,LimY,no_fim]) :- Z is Y+1, not(pertence([Z],LimY)), pertence([X],E).  %sobe
s([X,Y,S,F,L,P,E,G,D,LimX,LimY,no_fim],[X,Z,S,F,L,P,E,G,D,LimX,LimY,no_fim]) :- Z is Y-1, Z >= 0, pertence([X],E).  %desce


retirar_elemento(Elem,[Elem|Cauda],Cauda).
retirar_elemento(Elem,[Cabeca|Cauda],[Cabeca|Resultado]) :- retirar_elemento(Elem,Cauda,Resultado).

pertence(Elem,[Elem|_ ]).
pertence(Elem,[ _| Cauda]) :- pertence(Elem,Cauda).

concatena([ ],L,L).
concatena([Cab|Cauda],L2,[Cab|Resultado]) :- concatena(Cauda,L2,Resultado).

inversao([],[]).
inversao([Cab|Cauda], Y):-inversao(Cauda,Inv), concatena(Inv,[Cab],Y).

solucao_bl(Inicial,SolInv) :- bl([[Inicial]],Solucao), inversao(Solucao,SolInv).
bl([[Estado|Caminho]|_],[Estado|Caminho]) :- meta(Estado).
bl([Primeiro|Outros], Solucao) :- estende(Primeiro,Sucessores),concatena(Outros,Sucessores,NovaFronteira),bl(NovaFronteira,Solucao).
estende([Estado|Caminho],ListaSucessores):- bagof( [Sucessor,Estado|Caminho], (s(Estado,Sucessor),not(pertence(Sucessor,[Estado|Caminho]))), ListaSucessores),!.
estende( _ ,[]).

