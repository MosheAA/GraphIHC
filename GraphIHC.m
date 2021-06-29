% Función para hacer grafo basado en una matriz de correlación
% Moshé A. Amarillo 2021

% Esta función crea un grafo de correlaciones en donde los vínculos (edges) son
% definidos por la significancia de la correlación y el grosor del vínculo
% es determinado por el valor de correlación.

% La función se alimenta a través de una hoja de cálculo de Excel: 
% Hoja 'pVals' = matriz de valores P. 
%      'CorrVals' = matriz de valores de correlación. 
% NOTA: 1. La primera fila de la hoja debe llevar el nombre de las estructuras
%       2. Es importante que la matriz tenga el mismo número de filas y
%       columnas. 
%% Cargar matriz de correlación
clear all
file_name = 'Nic-AdoB.xlsx';
% Valores p 
pVals = readmatrix(file_name,...
    'Sheet','pVals','Range','B2:O15',...
    'TreatAsMissing','nan');
nan_row = nan(1,14);            %Para agregar una fila que se pierde tras la importación
pVals = cat(1,nan_row,pVals);  
% Valores correlación
CorrVals = readmatrix(file_name,...
    'Sheet','CorrVals','Range','B2:O15',...
    'TreatAsMissing','nan');
CorrVals = cat(1,nan_row,CorrVals); 
clear nan_row
% Nombres estructuras
StrucNam = readcell(file_name,...
    'Sheet','CorrVals','Range','B1:O1');
%% Seleccionar correlaciones significativas
p_thrshold = 0.06;              % pVal Umbral   
num_rows = size(CorrVals,1);    % Número de filas (para construir matriz de valores )
CorrV_thr = nan(num_rows,num_rows); 
pval_logic = pVals<=p_thrshold; 
CorrV_thr(pval_logic) = CorrVals(pval_logic); % Incluir en la nueva matriz los valores con p<umbral 
CorrV_thr = abs(CorrV_thr.^3);
CorrV_thr(isnan(CorrV_thr)) = 0;  % convertir Nan en 0. 

%% Crear figura
% Aquí se utiliza la función 'circularGraph'
% No olvidar citar la fuente. [Paul Kassebaum (2021). circularGraph
% (https://github.com/paul-kassebaum-mathworks/circularGraph), GitHub. Retrieved June 22, 2021.]

t = tiledlayout('flow');
nexttile
circularGraph(CorrV_thr,'Label',StrucNam)


%%
% Número de edges 
nexttile([2 3])
G = graph(CorrV_thr,StrucNam,'lower');
G_deg = degree(G);

T = table(G.Nodes.Name,G_deg,'VariableNames',{'Names','Degree'});
T = sortrows(T,'Degree','ascend');
y = T.Degree;
bar(y)
xticklabels(T.Names)
xlabel('Degree')


% Distancias
% G_dist = distances(G);
% 
% histogram(G_dist)
% plot(G)
% %%
% C = imread('Plantillacerebrosagital.png');
% image(C)
% hold on
% plot(G)

