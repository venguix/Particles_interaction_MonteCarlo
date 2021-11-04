function []=CreationAppelFonction(fichierAOuvrir)
%Attention NBDONNEEMAX=2147483648 environ 2730 images

%
% fichierAOuvrir=struct('champsSpecifiques',struct('type',{'Dose','Dose','Dose','Dose',...
%     'Epid','Epid','Epid','Epid'},'name',{'ImageDosePatientCQRC3D.txt','ImageDosePatientCQRCMI.txt',...
%     'ImageDosePatientInVivoRC3D.txt','ImageDosePatientInVivoRCMI.txt',...
%     'ImageEPIDPatientCQRC3D.txt','ImageEPIDPatientCQRCMI.txt',...
%     'ImageEPIDPatientInVivoRC3D.txt','ImageEPIDPatientInVivoRCMI.txt'},...
%     'fichierVoulu',{1,0,0,0,1,0,0,0},'normalisationParEntreesSorties',{0,0,0,0,0,0,0,0},'normalisationParImage',{0,0,0,0,0,0,0,0},...
%     'normalisationParCouple',{0,0,0,0,0,0,0,0},'inverseColor',{1,1,1,1,0,0,0,0},'threshold',{10,10,10,10,10,10,10,10},...
%     'facteurCorrection',{1,1,1,1,1,1,1,1},'relationEntreesSorties',{1,2,3,4,1,2,3,4},...
%     'imageDecoupe',{'Dose','Dose','Dose','Dose','Dose','Dose','Dose','Dose'},...
%     'nbPatients',{1,1,'tous',1,1,1,'tous',1},'numPatients',{[1],[1],[1],[1],[1],[1],[1],[1]},...
%     'DecoupeImage',{0,0,0,0,0,0,0,0},...
%     'imresize',{{'oui',[384 512]},{'oui',[1]},{'oui',[1]},{'oui',[1]},{'oui',[1]},{'oui',[1]},{'oui',[1]},{'oui',[1]}}),...
%     'champsGloblaux',struct('normalisation',0,'normalisationParParametre',1,'flagToutCalculer',1,'positionPixels',1,'diffusionPixelsRayon',[1 0.768 2.5]));
%
% imageDecoupe peut contenir 'Dose' ou 'Epid'
%fichierAOuvrir.champsSpecifiques = orderfields(fichierAOuvrir.champsSpecifiques,[1:4,9:15,5:8])




%Y=struct('a',{{'foo','bar'}})

%fichierAOuvrir(10,1)={cellstr('cool2.txt')}
%fichierAOuvrir(10,2)={1}


eval(strcat(strcat('DrapFichierPatientModifie(',num2str([1:size(fichierAOuvrir.champsSpecifiques,2)]'),')'),' = 0;')');

fichierOuvertDose=find(and([fichierAOuvrir.champsSpecifiques.fichierVoulu], strcmp({fichierAOuvrir.champsSpecifiques.type},'Dose'))==1);
fichierOuvertEpid=find(and([fichierAOuvrir.champsSpecifiques.fichierVoulu], strcmp({fichierAOuvrir.champsSpecifiques.type},'Epid'))==1);


relationEntreesSortiesFichierVoulu=[fichierAOuvrir.champsSpecifiques(find([fichierAOuvrir.champsSpecifiques.fichierVoulu]==1)).relationEntreesSorties];
relationEntreesSortiesFichierVouluDegressif=relationEntreesSortiesFichierVoulu;
drap=0;
i=1;
while(drap==0)
    if(~isempty(relationEntreesSortiesFichierVouluDegressif))
        relationEntreesSortiesCell{i}=find([fichierAOuvrir.champsSpecifiques.relationEntreesSorties]==relationEntreesSortiesFichierVouluDegressif(1));
        if(size(relationEntreesSortiesCell{i},2)~=2)
            disp('il y a un probleme au niveau de la structure fichierAOuvrir.champsSpecifiques.relationEntreesSorties');
        end
        if(strcmp(fichierAOuvrir.champsSpecifiques(relationEntreesSortiesCell{i}(1)).type,'Dose') && strcmp(fichierAOuvrir.champsSpecifiques(relationEntreesSortiesCell{i}(2)).type,'Epid'))
            relationEntreesSortiesCellBon{i}(1)=relationEntreesSortiesCell{i}(2);
            relationEntreesSortiesCellBon{i}(2)=relationEntreesSortiesCell{i}(1);
        elseif(strcmp(fichierAOuvrir.champsSpecifiques(relationEntreesSortiesCell{i}(1)).type,'Epid') && strcmp(fichierAOuvrir.champsSpecifiques(relationEntreesSortiesCell{i}(2)).type,'Dose'))
            relationEntreesSortiesCellBon{i}(1)=relationEntreesSortiesCell{i}(1);
            relationEntreesSortiesCellBon{i}(2)=relationEntreesSortiesCell{i}(2);
        else
            disp('Il y a une incohérence, les fichiers Entrees Sorties ne sont pas de types différents');
        end
        
        relationEntreesSortiesFichierVouluDegressif(find(relationEntreesSortiesFichierVouluDegressif==relationEntreesSortiesFichierVouluDegressif(1)))=[];
    else
        drap=1;
    end
    i=i+1;
    
end

relationEntreesSorties=vertcat(relationEntreesSortiesCellBon{1:end});
% TraiteImageMax=[];
% TraiteImageMin=[];
% for i=1:size(relationEntreesSorties,1)
%     if((strcmp(fichierAOuvrir.champsSpecifiques(relationEntreesSorties(i,1)).imageDecoupe,'Dose') && ...
%             (fichierAOuvrir.champsSpecifiques(relationEntreesSorties(i,1)).inverseColor==1 && ...
%             fichierAOuvrir.champsSpecifiques(relationEntreesSorties(i,2)).inverseColor==1 ) || ...
%             (strcmp(fichierAOuvrir.champsSpecifiques(relationEntreesSorties(i,1)).type,'Dose') &&...
%             fichierAOuvrir.champsSpecifiques(relationEntreesSorties(i,1)).inverseColor==1 && ...
%             fichierAOuvrir.champsSpecifiques(relationEntreesSorties(i,2)).inverseColor==0) ||...
%             (strcmp(fichierAOuvrir.champsSpecifiques(relationEntreesSorties(i,1)).type,'Epid') &&...
%             fichierAOuvrir.champsSpecifiques(relationEntreesSorties(i,1)).inverseColor==0 && ...
%             fichierAOuvrir.champsSpecifiques(relationEntreesSorties(i,2)).inverseColor==1)) || ...
%             (strcmp(fichierAOuvrir.champsSpecifiques(relationEntreesSorties(i,1)).imageDecoupe,'Epid') && ...
%             (fichierAOuvrir.champsSpecifiques(relationEntreesSorties(i,1)).inverseColor==0 && ...
%             fichierAOuvrir.champsSpecifiques(relationEntreesSorties(i,2)).inverseColor==0 ) || ...
%             (strcmp(fichierAOuvrir.champsSpecifiques(relationEntreesSorties(i,1)).type,'Dose') &&...
%             fichierAOuvrir.champsSpecifiques(relationEntreesSorties(i,1)).inverseColor==1 && ...
%             fichierAOuvrir.champsSpecifiques(relationEntreesSorties(i,2)).inverseColor==0) ||...
%             (strcmp(fichierAOuvrir.champsSpecifiques(relationEntreesSorties(i,1)).type,'Epid') &&...
%             fichierAOuvrir.champsSpecifiques(relationEntreesSorties(i,1)).inverseColor==0 && ...
%             fichierAOuvrir.champsSpecifiques(relationEntreesSorties(i,2)).inverseColor==1)))
%         TraiteImageMax(length(TraiteImageMax)+1)=fichierAOuvrir.champsSpecifiques(relationEntreesSorties(i,1)).relationEntreesSorties;
%     elseif((strcmp(fichierAOuvrir.champsSpecifiques(relationEntreesSorties(i,1)).imageDecoupe,'Dose') && ...
%             (fichierAOuvrir.champsSpecifiques(relationEntreesSorties(i,1)).inverseColor==0 && ...
%             fichierAOuvrir.champsSpecifiques(relationEntreesSorties(i,2)).inverseColor==0 ) || ...
%             (strcmp(fichierAOuvrir.champsSpecifiques(relationEntreesSorties(i,1)).type,'Dose') &&...
%             fichierAOuvrir.champsSpecifiques(relationEntreesSorties(i,1)).inverseColor==0 && ...
%             fichierAOuvrir.champsSpecifiques(relationEntreesSorties(i,2)).inverseColor==1) ||...
%             (strcmp(fichierAOuvrir.champsSpecifiques(relationEntreesSorties(i,1)).type,'Epid') &&...
%             fichierAOuvrir.champsSpecifiques(relationEntreesSorties(i,1)).inverseColor==1 && ...
%             fichierAOuvrir.champsSpecifiques(relationEntreesSorties(i,2)).inverseColor==0)) || ...
%             (strcmp(fichierAOuvrir.champsSpecifiques(relationEntreesSorties(i,1)).imageDecoupe,'Epid') && ...
%             (fichierAOuvrir.champsSpecifiques(relationEntreesSorties(i,1)).inverseColor==1 && ...
%             fichierAOuvrir.champsSpecifiques(relationEntreesSorties(i,2)).inverseColor==1 ) || ...
%             (strcmp(fichierAOuvrir.champsSpecifiques(relationEntreesSorties(i,1)).type,'Dose') &&...
%             fichierAOuvrir.champsSpecifiques(relationEntreesSorties(i,1)).inverseColor==0 && ...
%             fichierAOuvrir.champsSpecifiques(relationEntreesSorties(i,2)).inverseColor==1) ||...
%             (strcmp(fichierAOuvrir.champsSpecifiques(relationEntreesSorties(i,1)).type,'Epid') &&...
%             fichierAOuvrir.champsSpecifiques(relationEntreesSorties(i,1)).inverseColor==1 && ...
%             fichierAOuvrir.champsSpecifiques(relationEntreesSorties(i,2)).inverseColor==0)))
%         TraiteImageMin(length(TraiteImageMin)+1)=fichierAOuvrir.champsSpecifiques(relationEntreesSorties(i,1)).relationEntreesSorties;
%     else
%         Affichage=sprintf('il y a incoherence au niveau du traitement d image ');
%         disp(Affichage);
%     end
%     
% end

if (find(vertcat(fichierAOuvrir.champsSpecifiques(relationEntreesSorties(:)).fichierVoulu))~=1)
    Affichage=sprintf('il y a incoherence avec les fichiers à ouvrir');
    disp(Affichage);
end
%Attention, relationEntreesSorties(i,:) est de la forme [Epid Dose]
for(i=1:size(relationEntreesSorties,1))
    if(~strcmp(fichierAOuvrir.champsSpecifiques(relationEntreesSorties(i,1)).imageDecoupe,fichierAOuvrir.champsSpecifiques(relationEntreesSorties(i,2)).imageDecoupe))
        Affichage=sprintf('il y a incoherence entre fichierAOuvrir.champsSpecifiques(%d).imageDecoupe et fichierAOuvrir.champsSpecifiques(%d).imageDecoupe qui ont la meme relation entrees sorties',relationEntreesSorties(i,1),relationEntreesSorties(i,2));
        disp(Affichage);
    else
        if(strcmp(fichierAOuvrir.champsSpecifiques(relationEntreesSorties(i,1)).imageDecoupe,fichierAOuvrir.champsSpecifiques(relationEntreesSorties(i,1)).type))
            champsIndex(i)=relationEntreesSorties(i,1);
            
        elseif(strcmp(fichierAOuvrir.champsSpecifiques(relationEntreesSorties(i,1)).imageDecoupe,fichierAOuvrir.champsSpecifiques(relationEntreesSorties(i,2)).type))
            champsIndex(i)=relationEntreesSorties(i,2);
            
        end
    end
end


for i=1:size(fichierAOuvrir.champsSpecifiques,2)
   % securiteTraiteImage=0;
    if(fichierAOuvrir.champsSpecifiques(i).fichierVoulu==1)
        dateAlgorithmeModifie=['dateAlgorithmeModifie',num2str(i),'.txt'];
        
        if(exist(dateAlgorithmeModifie)~=2)
            system(['touch /Users/Fred/Desktop/These/RdN/code/Donnee/' dateAlgorithmeModifie]);
            DrapFichierPatientModifie(i)=1;
        else
            dateFichierPatientModifie=dir(['/Users/Fred/Desktop/These/RdN/code/Donnee/' fichierAOuvrir.champsSpecifiques(i).name]);
            dateFichierPatientModifie=dateFichierPatientModifie(1).datenum;
            nomFichierDateAlgorithmeModifie=['dateAlgorithmeModifie' num2str(i) '.txt'];
            NomFichierDateAlgorithmeModifie = fopen(nomFichierDateAlgorithmeModifie, 'r');
            dateAlgorithmeModifie=textscan(fopNomFichierDateAlgorithmeModifie,'%s');
            fclose(fopNomFichierDateAlgorithmeModifie);
            
            if(~isempty(dateAlgorithmeModifie{1}))
                formatIn='dd-mmm-yyyy HH:MM:SS';
                dateAlgorithmeModifie=datenum(strcat(dateAlgorithmeModifie{1}{1},32,dateAlgorithmeModifie{1}{2}),formatIn);
                if(dateFichierPatientModifie>dateAlgorithmeModifie || fichierAOuvrir.champsGloblaux.flagToutCalculer==1)
                    DrapFichierPatientModifie(i)=1;
                end
            else
                DrapFichierPatientModifie(i)=1;
            end
        end
        
        nomFichierImagePatient=fichierAOuvrir.champsSpecifiques(i).name;
        fopNomFichierImagePatient = fopen(nomFichierImagePatient, 'r');
        nomPatient{i}=textscan(fopNomFichierImagePatient,'%s');
        fclose(fopNomFichierImagePatient);
        if(~strcmp(fichierAOuvrir.champsSpecifiques(i).nbPatients,'tous'))
            nomPatient{i}=nomPatient{i}{1}(fichierAOuvrir.champsSpecifiques(i).numPatients);
        else
            nomPatient{i}=nomPatient{i}{1};
        end
        
        nomPatient2{i}=strrep(nomPatient{i}(1:end),'.dcm','');
        nomPatient2{i}(1:end)=strrep(nomPatient2{i}(1:end),'.','_');
        
        
        if(DrapFichierPatientModifie(i)==1)
            
            AppelFonction=['AppelFonction',num2str(i),'.m'];
            
            if(exist(AppelFonction)==2)
                delete(AppelFonction);
            end
            system(['touch /Users/Fred/Desktop/These/RdN/code/Donnee/' AppelFonction]);
            
            fopNomFichierAppelFonction = fopen(AppelFonction, 'w');
            
            % nomPatient{i}(1:end)=strrep(cellstr(str2mat(nomPatient{i}(1:end))),'.dcm','');
            % nomPatient{i}(1:end)=strrep(cellstr(str2mat(nomPatient{i}(1:end))),'.','_');
            
            if (fichierAOuvrir.champsSpecifiques(i).inverseColor==1)
                inverseColor='InverseColor(';
                inverseColorFin=')';
            else
                inverseColor='';
                inverseColorFin='';
            end
            nomFonction=strcat(nomPatient2{i}(1:end),'=',inverseColor, 'double(dicomread(',char(39),nomPatient{i}(1:end),char(39),'))', inverseColorFin, ';');
            
            fprintf(fopNomFichierAppelFonction,'%s\n',nomFonction{1:end});
            if(~isempty(find(fichierOuvertEpid==i)) && fichierAOuvrir.champsSpecifiques(i).facteurCorrection==1)
                
                fprintf(fopNomFichierAppelFonction,['mot1=' char(39) 'Averaged Frames ' char(39) ';\n']);
                fprintf(fopNomFichierAppelFonction,['mot2=' char(39) 'Dark Field' char(39) ';\n']);
                
                nomFonction=strcat('info',nomPatient2{i}(1:end),'=dicominfo(',char(39),nomPatient{i}(1:end),char(39),');');
                
                fprintf(fopNomFichierAppelFonction,'%s\n',nomFonction{1:end});
                
                nomFonction=strcat('ind1',nomPatient2{i}(1:end),'=strfind(info',nomPatient2{i}(1:end),'.RTImageDescription,mot1);');
                fprintf(fopNomFichierAppelFonction,'%s\n',nomFonction{1:end});
                
                nomFonction=strcat('ind2',nomPatient2{i}(1:end),'=strfind(info',nomPatient2{i}(1:end),'.RTImageDescription,mot2);');
                fprintf(fopNomFichierAppelFonction,'%s\n',nomFonction{1:end});
                
                nomFonction=strcat(nomPatient2{i}(1:end),'=',nomPatient2{i}(1:end),'.*str2num(info',nomPatient2{i}(1:end),'.RTImageDescription(ind1',nomPatient2{i}(1:end),'+length(mot1):ind2',nomPatient2{i}(1:end),'-1));');
                fprintf(fopNomFichierAppelFonction,'%s\n',nomFonction{1:end});
                
            end
            if(~isempty(find(fichierOuvertDose==i)) && fichierAOuvrir.champsSpecifiques(i).facteurCorrection==1)
                nomFonction=strcat('info',nomPatient2{i}(1:end),'=dicominfo(',char(39),nomPatient{i}(1:end),char(39),');');
                
                fprintf(fopNomFichierAppelFonction,'%s\n',nomFonction{1:end});
                
                nomFonction=strcat(nomPatient2{i}(1:end),'=',nomPatient2{i}(1:end),'.*info',nomPatient2{i}(1:end),'.DoseGridScaling;');
                fprintf(fopNomFichierAppelFonction,'%s\n',nomFonction{1:end});
            end
            if(strcmp(fichierAOuvrir.champsSpecifiques(i).imresize{1},'oui'))
                nomFonction=strcat(nomPatient2{i}(1:end),'=imresize(',nomPatient2{i}(1:end),',',mat2str(fichierAOuvrir.champsSpecifiques(i).imresize{2}),')', ';');
                fprintf(fopNomFichierAppelFonction,'%s\n',nomFonction{1:end});
            end
            if(fichierAOuvrir.champsSpecifiques(i).DecoupeImage>1)
                nomFonction=strcat(nomPatient2{i}(1:end),'=DecoupeImage(',nomPatient2{i}(1:end),',',mat2str(fichierAOuvrir.champsSpecifiques(i).DecoupeImage),')', ';');
                fprintf(fopNomFichierAppelFonction,'%s\n',nomFonction{1:end});
            end
            if (fichierAOuvrir.champsSpecifiques(i).normalisationParEntreesSorties==1)
                fprintf(fopNomFichierAppelFonction,'\n[');
                fprintf(fopNomFichierAppelFonction,['%s' ','],nomPatient2{i}{1:end-1});
                fprintf(fopNomFichierAppelFonction,['%s'],nomPatient2{i}{end});
                if(strcmp(fichierAOuvrir.champsSpecifiques(i).type,'Dose'))
                fprintf(fopNomFichierAppelFonction,',minVecteurDose%s',fichierAOuvrir.champsSpecifiques(i).name(1:end-4));
                fprintf(fopNomFichierAppelFonction,',maxVecteurDose%s',fichierAOuvrir.champsSpecifiques(i).name(1:end-4));
                fprintf(fopNomFichierAppelFonction,']=Normalisation(');
                elseif(strcmp(fichierAOuvrir.champsSpecifiques(i).type,'Epid'))
                fprintf(fopNomFichierAppelFonction,',minVecteurEpid%s',fichierAOuvrir.champsSpecifiques(i).name(1:end-4));
                fprintf(fopNomFichierAppelFonction,',maxVecteurEpid%s',fichierAOuvrir.champsSpecifiques(i).name(1:end-4));
                fprintf(fopNomFichierAppelFonction,']=Normalisation(');
                else
                Affichage=sprintf('Il y a un probleme dans la coherence du type');
                disp(Affichage);
                end
                fprintf(fopNomFichierAppelFonction,['%s' ','],nomPatient2{i}{1:end-1});
                fprintf(fopNomFichierAppelFonction,['%s'],nomPatient2{i}{end});
                fprintf(fopNomFichierAppelFonction,');');
%                 
            end
            if (fichierAOuvrir.champsSpecifiques(i).normalisationParImage==1)
                if (strcmp(fichierAOuvrir.champsSpecifiques(i).type,'Dose'))
                nomFonction=strcat('[',nomPatient2{i}(1:end),',minVecteurDose',nomPatient2{i}(1:end),',maxVecteurDose',nomPatient2{i}(1:end),']=Normalisation(',nomPatient2{i}(1:end),');');
                fprintf(fopNomFichierAppelFonction,'%s\n',nomFonction{1:end});
                else
                nomFonction=strcat('[',nomPatient2{i}(1:end),',minVecteurEpid',nomPatient2{i}(1:end),',maxVecteurEpid',nomPatient2{i}(1:end),']=Normalisation(',nomPatient2{i}(1:end),');');
                fprintf(fopNomFichierAppelFonction,'%s\n',nomFonction{1:end});
                    
                end
            end
            
            if (fichierAOuvrir.champsSpecifiques(i).normalisationParCouple==1)

            end
            
            if(strcmp(fichierAOuvrir.champsSpecifiques(i).imageDecoupe,'Dose'))
                eval(['doseOrEpid=find(fichierOuvertDose==' num2str(i) ');']);
            elseif(strcmp(fichierAOuvrir.champsSpecifiques(i).imageDecoupe,'Epid'))
                eval(['doseOrEpid=find(fichierOuvertEpid==' num2str(i) ');']);
            else
                Affichage=sprintf('Il y a un probleme dans la coherence de strcmp(fichierAOuvrir.champsSpecifiques(%d).imageDecoupe',i);
                disp(Affichage);
            end
            
            if(~isempty(doseOrEpid))
                    fprintf(fopNomFichierAppelFonction,'\n[');
                    
                    nomFonction=strcat('mask',nomPatient2{i}(1:end),',row',nomPatient2{i}(1:end),',col',nomPatient2{i}(1:end),',');
                    nomFonction=nomFonction';
                    nomFonction=nomFonction(:)';
                   % nomFonction=horzcat(nomFonction);
                    nomFonction=horzcat(nomFonction{1:end});
                    
                    
                    
%                     if(size(nomPatient2{i},1)~=1)
%                         fprintf(fopNomFichierAppelFonction,['mask' '%s' ','],nomPatient2{i}{1:end-1});
%                     end 
%                     
%                     fprintf(fopNomFichierAppelFonction,['mask' '%s' ','],nomPatient2{i}{end});
%                     
%                      if(size(nomPatient2{i},1)~=1)
%                         fprintf(fopNomFichierAppelFonction,['row' '%s' ','],nomPatient2{i}{1:end-1});
%                     end 
%                     fprintf(fopNomFichierAppelFonction,['row' '%s' ','],nomPatient2{i}{end});
%                     
%                      if(size(nomPatient2{i},1)~=1)
%                         fprintf(fopNomFichierAppelFonction,['col' '%s' ','],nomPatient2{i}{1:end-1});
%                     end 
                    fprintf(fopNomFichierAppelFonction,'%s',nomFonction);
                    
                    fprintf(fopNomFichierAppelFonction,']=TraiteImage(');
                    fprintf(fopNomFichierAppelFonction,['%d' ','],fichierAOuvrir.champsSpecifiques(i).threshold);
                    if(size(nomPatient2{i},1)~=1)
                        fprintf(fopNomFichierAppelFonction,['%s' ','],nomPatient2{i}{1:end-1});
                    end
                    fprintf(fopNomFichierAppelFonction,['%s'],nomPatient2{i}{end});
                    fprintf(fopNomFichierAppelFonction,');');


%                 if(~isempty(find(TraiteImageMax==fichierAOuvrir.champsSpecifiques(i).relationEntreesSorties)))
%                     fprintf(fopNomFichierAppelFonction,'\n[');
%                     if(size(nomPatient2{i},1)~=1)
%                         fprintf(fopNomFichierAppelFonction,['mask' '%s' ','],nomPatient2{i}{1:end-1});
%                     end
%                     fprintf(fopNomFichierAppelFonction,['mask' '%s'],nomPatient2{i}{end});
%                     fprintf(fopNomFichierAppelFonction,']=TraiteImageMax(');
%                     fprintf(fopNomFichierAppelFonction,['%d' ','],fichierAOuvrir.champsSpecifiques(i).threshold);
%                     if(size(nomPatient2{i},1)~=1)
%                         fprintf(fopNomFichierAppelFonction,['%s' ','],nomPatient2{i}{1:end-1});
%                     end
%                     fprintf(fopNomFichierAppelFonction,['%s'],nomPatient2{i}{end});
%                     fprintf(fopNomFichierAppelFonction,');');
%                     securiteTraiteImage=securiteTraiteImage+1;
%                 end
%                 if(~isempty(find(TraiteImageMin==fichierAOuvrir.champsSpecifiques(i).relationEntreesSorties)))
%                     fprintf(fopNomFichierAppelFonction,'\n[');
%                     if(size(nomPatient2{i},1)~=1)
%                         fprintf(fopNomFichierAppelFonction,['mask' '%s' ','],nomPatient2{i}{1:end-1});
%                     end
%                     fprintf(fopNomFichierAppelFonction,['mask' '%s'],nomPatient2{i}{end});
%                     fprintf(fopNomFichierAppelFonction,']=TraiteImageMin(');
%                     fprintf(fopNomFichierAppelFonction,['%d' ','],fichierAOuvrir.champsSpecifiques(i).threshold);
%                     if(size(nomPatient2{i},1)~=1)
%                         fprintf(fopNomFichierAppelFonction,['%s' ','],nomPatient2{i}{1:end-1});
%                     end
%                     fprintf(fopNomFichierAppelFonction,['%s'],nomPatient2{i}{end});
%                     fprintf(fopNomFichierAppelFonction,');');
%                     securiteTraiteImage=securiteTraiteImage+1;
%                 end
                
%                 if(securiteTraiteImage==2)
%                     Affichage=sprintf('il y a incoherence au niveau du traitement d image, plusieurs fonctions sont appellees');
%                     disp(Affichage);
%                 end



%                 if(fichierAOuvrir.champsSpecifiques(i).threshold~=0)
%                     nomFonction=strcat('[row',nomPatient2{i}(1:end),',col',nomPatient2{i}(1:end),']=find(mask',nomPatient2{i}(1:end),'~=max(mask',nomPatient2{i}(1:end),'(:)));');
%                 else
%                     nomFonction=strcat('[row',nomPatient2{i}(1:end),',col',nomPatient2{i}(1:end),']=find(mask',nomPatient2{i}(1:end),'~=NaN);');
%                     
%                 end
%                fprintf(fopNomFichierAppelFonction,'\n%s\n',nomFonction{1:end});
                nomFonction=strcat('idx',nomPatient2{i}(1:end),'=sub2ind(size(mask',nomPatient2{i}(1:end),'),row',nomPatient2{i}(1:end),',col',nomPatient2{i}(1:end),');');
                fprintf(fopNomFichierAppelFonction,'%s\n',nomFonction{1:end});
            end
            
            fclose(fopNomFichierAppelFonction);
            
            nomFichierDateAlgorithmeModifie=['dateAlgorithmeModifie' num2str(i) '.txt'];
            delete(nomFichierDateAlgorithmeModifie);
            system(['touch /Users/Fred/Desktop/These/RdN/code/Donnee/' nomFichierDateAlgorithmeModifie]);
            fopNomFichierDateAlgorithmeModifie = fopen(nomFichierDateAlgorithmeModifie, 'w');
            fprintf(fopNomFichierDateAlgorithmeModifie,'%s',datestr(now));
            fclose(fopNomFichierDateAlgorithmeModifie);
            
        end
    end
end

AppelFonctionRdN='AppelFonctionRdN.m';

if(exist(AppelFonctionRdN)==2)
    delete(AppelFonctionRdN);
end

system(['touch /Users/Fred/Desktop/These/RdN/code/Donnee/' AppelFonctionRdN]);

if(size(relationEntreesSorties,1)~=1)
    EntreesRdN=[strcat(vertcat(nomPatient2{relationEntreesSorties(1:end-1,1)}),'(idx',vertcat(nomPatient2{champsIndex(1:end-1)}),');');strcat(nomPatient2{relationEntreesSorties(end,1)}(1:end-1),'(idx',nomPatient2{champsIndex(end)}(1:end-1),');');strcat(nomPatient2{relationEntreesSorties(end,1)}(end),'(idx',nomPatient2{champsIndex(end)}(end),')')];
    SortiesRdN=[strcat(vertcat(nomPatient2{relationEntreesSorties(1:end-1,2)}),'(idx',vertcat(nomPatient2{champsIndex(1:end-1)}),');');strcat(nomPatient2{relationEntreesSorties(end,2)}(1:end-1),'(idx',nomPatient2{champsIndex(end)}(1:end-1),');');strcat(nomPatient2{relationEntreesSorties(end,1)}(end),'(idx',nomPatient2{champsIndex(end)}(end),')')];
else
    EntreesRdN=[strcat(nomPatient2{relationEntreesSorties(end,1)}(1:end-1),'(idx',nomPatient2{champsIndex(end)}(1:end-1),');');strcat(nomPatient2{relationEntreesSorties(end,1)}(end),'(idx',nomPatient2{champsIndex(end)}(end),')')];
    SortiesRdN=[strcat(nomPatient2{relationEntreesSorties(end,2)}(1:end-1),'(idx',nomPatient2{champsIndex(end)}(1:end-1),');');strcat(nomPatient2{relationEntreesSorties(end,2)}(end),'(idx',nomPatient2{champsIndex(end)}(end),')')];
end

fopNomFichierAppelFonctionRdN = fopen(AppelFonctionRdN, 'w');
if(fichierAOuvrir.champsGloblaux.normalisationParParametre==1)
    if(size(fichierOuvertDose,2)~=1)
        parametresNormalisation=[strcat(vertcat(nomPatient2{fichierOuvertDose(1:end-1)}),',');strcat(nomPatient2{fichierOuvertDose(end)}(1:end-1),',');nomPatient2{fichierOuvertDose(end)}(end)];
        borneParametreNormalisation=',minVecteurDose,maxVecteurDose';
    else
        parametresNormalisation=[strcat(nomPatient2{fichierOuvertDose(end)}(1:end-1),',');nomPatient2{fichierOuvertDose(end)}(end)];
        borneParametreNormalisation=',minVecteurDose,maxVecteurDose';
    end
    fprintf(fopNomFichierAppelFonctionRdN,'[');
    fprintf(fopNomFichierAppelFonctionRdN,'%s',parametresNormalisation{1:end});
    fprintf(fopNomFichierAppelFonctionRdN,'%s',borneParametreNormalisation);

    fprintf(fopNomFichierAppelFonctionRdN,[']=Normalisation(']);
    fprintf(fopNomFichierAppelFonctionRdN,'%s',parametresNormalisation{1:end});
    fprintf(fopNomFichierAppelFonctionRdN,[');\n']);
    if(size(fichierOuvertEpid,2)~=1)
        parametresNormalisation=[strcat(vertcat(nomPatient2{fichierOuvertEpid(1:end-1)}),',');strcat(nomPatient2{fichierOuvertEpid(end)}(1:end-1),',');nomPatient2{fichierOuvertEpid(end)}(end)];
        borneParametreNormalisation=',minVecteurEpid,maxVecteurEpid';
    else
        parametresNormalisation=[strcat(nomPatient2{fichierOuvertEpid(end)}(1:end-1),',');nomPatient2{fichierOuvertEpid(end)}(end)];
        borneParametreNormalisation=',minVecteurEpid,maxVecteurEpid';
    end
    
    fprintf(fopNomFichierAppelFonctionRdN,'[');
    fprintf(fopNomFichierAppelFonctionRdN,'%s',parametresNormalisation{1:end});
    fprintf(fopNomFichierAppelFonctionRdN,'%s',borneParametreNormalisation);
    fprintf(fopNomFichierAppelFonctionRdN,[']=Normalisation(']);
    fprintf(fopNomFichierAppelFonctionRdN,'%s',parametresNormalisation{1:end});
    fprintf(fopNomFichierAppelFonctionRdN,[');\n']);
end

if(fichierAOuvrir.champsGloblaux.normalisation==1)
    parametresNormalisation=[strcat(vertcat(nomPatient2{1:end-1}),',');strcat(nomPatient2{end}(1:end-1),',');nomPatient2{end}(end)];
    fprintf(fopNomFichierAppelFonctionRdN,'[');
    fprintf(fopNomFichierAppelFonctionRdN,'%s',parametresNormalisation{1:end});
    fprintf(fopNomFichierAppelFonctionRdN,'%s',',minVecteurGlobal,maxVecteurGlobal');
    fprintf(fopNomFichierAppelFonctionRdN,[']=Normalisation(']);
    fprintf(fopNomFichierAppelFonctionRdN,'%s',parametresNormalisation{1:end});
    fprintf(fopNomFichierAppelFonctionRdN,[');\n']);
end
fprintf(fopNomFichierAppelFonctionRdN,'E=[');
fprintf(fopNomFichierAppelFonctionRdN,'%s',EntreesRdN{1:end});
fprintf(fopNomFichierAppelFonctionRdN,[']' char(39) ';\n']);
fprintf(fopNomFichierAppelFonctionRdN,'T=[');
fprintf(fopNomFichierAppelFonctionRdN,'%s',SortiesRdN{1:end});
fprintf(fopNomFichierAppelFonctionRdN,[']' char(39) ';\n']);

% fprintf(fopNomFichierAppelFonctionRdN,'Ecool=[');
% Ecool=strcat('minVecteurEpid',vertcat(nomPatient2{10}),{' '},'maxVecteurEpid',vertcat(nomPatient2{10}),';');
% 
% fprintf(fopNomFichierAppelFonctionRdN,'%s',Ecool{1:end});
% fprintf(fopNomFichierAppelFonctionRdN,['];\n']);
% 
% fprintf(fopNomFichierAppelFonctionRdN,'Tcool=[');
% Tcool=strcat('minVecteurDose',vertcat(nomPatient2{9}),{' '},'maxVecteurDose',vertcat(nomPatient2{9}),';');
% 
% fprintf(fopNomFichierAppelFonctionRdN,'%s',Tcool{1:end});
% fprintf(fopNomFichierAppelFonctionRdN,['];\n']);



if(fichierAOuvrir.champsGloblaux.positionPixels==1)
    
    if(size(relationEntreesSorties,1)~=1)
        EntreesRdN=[strcat('row',vertcat(nomPatient2{champsIndex(1:end-1)}),';');strcat('row',nomPatient2{champsIndex(end)}(1:end-1),';');strcat('row',nomPatient2{champsIndex(end)}(end))];
    else
        EntreesRdN=[strcat('row',nomPatient2{champsIndex(end)}(1:end-1),';');strcat('row',nomPatient2{champsIndex(end)}(end))];
    end
    
    fprintf(fopNomFichierAppelFonctionRdN,'Eposx=[');
    fprintf(fopNomFichierAppelFonctionRdN,'%s',EntreesRdN{1:end});
    fprintf(fopNomFichierAppelFonctionRdN,[']' char(39) ';\n']);
    
    if(size(relationEntreesSorties,1)~=1)
        EntreesRdN=[strcat('col',vertcat(nomPatient2{champsIndex(1:end-1)}),';');strcat('col',nomPatient2{champsIndex(end)}(1:end-1),';');strcat('col',nomPatient2{champsIndex(end)}(end))];
    else
        EntreesRdN=[strcat('col',nomPatient2{champsIndex(end)}(1:end-1),';');strcat('col',nomPatient2{champsIndex(end)}(end))];
    end
    
    fprintf(fopNomFichierAppelFonctionRdN,'Eposy=[');
    fprintf(fopNomFichierAppelFonctionRdN,'%s',EntreesRdN{1:end});
    fprintf(fopNomFichierAppelFonctionRdN,[']' char(39) ';\n']);
    
    fprintf(fopNomFichierAppelFonctionRdN,'E=[E;Eposx;Eposy];\n');
    
end


if(fichierAOuvrir.champsGloblaux.diffusionPixelsRayon(1)==1)
    
        %EMatDiffRD_DIPIAZZA_OAD_OPEN=MatriceDiffusionPixelsGenerique(30,RD_DIPIAZZA_OAD_OPEN,rowRD_DIPIAZZA_OAD_OPEN,colRD_DIPIAZZA_OAD_OPEN);

    EntreesRdN=strcat('EMatDiff',vertcat(nomPatient2{champsIndex}),'=MatriceDiffusionPixelsGenerique(',num2str(fichierAOuvrir.champsGloblaux.diffusionPixelsRayon(3)/fichierAOuvrir.champsGloblaux.diffusionPixelsRayon(2)),',','mask',vertcat(nomPatient2{champsIndex}),',row',vertcat(nomPatient2{champsIndex}),',col',vertcat(nomPatient2{champsIndex}),');');
    
    fprintf(fopNomFichierAppelFonctionRdN,'\n%s\n',EntreesRdN{1:end});
    
    if(size(relationEntreesSorties,1)~=1)
        EntreesRdN=[strcat('EMatDiff',vertcat(nomPatient2{champsIndex(1:end-1)}),{' '});strcat('EMatDiff',nomPatient2{champsIndex(end)}(1:end-1),{' '});strcat('EMatDiff',nomPatient2{champsIndex(end)}(end))];
    else
        EntreesRdN=[strcat('EMatDiff',nomPatient2{champsIndex(end)}(1:end-1),{' '});strcat('EMatDiff',nomPatient2{champsIndex(end)}(end))];
    end
    
    fprintf(fopNomFichierAppelFonctionRdN,'EMatDiff=[');
    fprintf(fopNomFichierAppelFonctionRdN,'%s',EntreesRdN{1:end});
    fprintf(fopNomFichierAppelFonctionRdN,['];\n']);
    
    fprintf(fopNomFichierAppelFonctionRdN,'E=[E;EMatDiff];\n');
    
end

fclose(fopNomFichierAppelFonctionRdN);


%%Fermeture des fenêtres
FenetreOuverte = matlab.desktop.editor.getAll;
% FenetreAFermer{1}=AppelFonctionRdNEntrees;
% FenetreAFermer{2}=AppelFonctionRdNSorties;
% FenetreAFermer{3}=AppelFonctionNormalisationGobale;

FenetreAFermer{1}=AppelFonctionRdN;

%FenetreAFermer=strcat('/Users/Fred/Desktop/These/RdN/code/Donnee/',FenetreAFermer(1:3));
FenetreAFermer=strcat('/Users/Fred/Desktop/These/RdN/code/Donnee/',FenetreAFermer(1));

% FenetreAFermer{1}=strcmp({FenetreOuverte(1:end).Filename}',FenetreAFermer{1});
% FenetreAFermer{2}=strcmp({FenetreOuverte(1:end).Filename}',FenetreAFermer{2});
% FenetreAFermer{3}=strcmp({FenetreOuverte(1:end).Filename}',FenetreAFermer{3});

FenetreAFermer{1}=strcmp({FenetreOuverte(1:end).Filename}',FenetreAFermer{1});

%FenetreAFermer=FenetreAFermer{1}+FenetreAFermer{2}+FenetreAFermer{3};
FenetreAFermer=FenetreAFermer{1};

if(~isempty(find(FenetreAFermer==1)))
    FenetreOuverte(find(FenetreAFermer==1)).close;
end

[row]=find(DrapFichierPatientModifie==1);
if(~isempty(row))
    %A(1:3)={X(1:3).Filename}
    AppelFonction=strcat('AppelFonction',num2str([1:size(fichierAOuvrir.champsSpecifiques,2)]'),'.m');
    FenetreAFermer=cellstr(strcat('/Users/Fred/Desktop/These/RdN/code/Donnee/dateAlgorithmeModifie',num2str(row'),'.txt'));
    for(j=1:size(FenetreAFermer,1))
        
        FenetreAFermer{j}=strcmp({FenetreOuverte(1:end).Filename}',FenetreAFermer{j});
        FenetreAFermer{j}(length(FenetreOuverte)+1:2*length(FenetreOuverte))=strcmp({FenetreOuverte(1:end).Filename}',['/Users/Fred/Desktop/These/RdN/code/Donnee/' AppelFonction(row(j),:)]);
        FenetreAFermer{j}=FenetreAFermer{j}(1:length(FenetreOuverte))+FenetreAFermer{j}(length(FenetreOuverte)+1:2*length(FenetreOuverte));
        if(~isempty(find(FenetreAFermer{j}==1)))
            FenetreOuverte(find(FenetreAFermer{j}==1)).close;
        end
    end
end
end