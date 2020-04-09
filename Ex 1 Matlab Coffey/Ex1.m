%%%%% NAPE @ HOME STATISTICS COURSE EXERCISE 1 %%%%
% Kevin Coffey - 04/09/2020                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % Start Fresh
clear all

% % Load from relative path
t=readtable('College.csv');

% Load from abosute path
% t=readtable("C:\Users\MrCoffey\Desktop\NAPE Computing\Python Tutorials\Ex 1 Matlab Coffey\College.csv");

% Look at first 10 entries
t(1:10,:) % t(row 1 through 10, column all)

% % It looks like column 1 should contain University Names, Lets Seperate them
names=t(:,1);
t=t(:,2:end);

% % There is 1 categorical variable, so lets make it categorical and not text
t.Private=categorical(t.Private);

% Get a summary of the data
s = summary(t)

% Retrieve a summary statistic (the median age)
s.Books.Median

% Create variable correlation scatter plot of 10 contuinuous variables
f1=figure('color','w','position',[10 10 900 900]) % This part is not necessary but will make things pretty
corrplot(t(:,2:11))

% Compare private and public colleges
% Many options are available | statarray = grpstats(tbl,groupvar,whichstats,Name,Value)
% Default gives count and mean
stats=grpstats(t,'Private')

%% Plotting using gramm - similar to ggplot etc.
f2=figure('Position',[10 10 900 350]);

% You can plot many subplots by using g(row,column)
% Single plots with g=gramm (make a new figure and g.draw for each)

% Super simple
g(1,1)=gramm('x',t.Private,'y',t.Outstate);
g(1,1).set_title('Simple');
g(1,1).stat_boxplot();

% Better Looking - all functions are pretty self-explanitory
g(1,2)=gramm('x',t.Private,'y',t.Outstate,'color',t.Private); % Add a new color for the private variable
g(1,2).set_title('All Colleges');
g(1,2).stat_violin('normalization','width','half',0,'dodge',0,'fill','transparent')
g(1,2).stat_boxplot('width',.2);
g(1,2).axe_property('LineWidth',1.5,'FontSize',12);
g(1,2).set_names('x','Private','y','Out of State Students','color',{});
g(1,2).no_legend();

% We don't need a new variable to graph just elite colleges, just use the
g(1,3)=gramm('x',t.Private,'y',t.Outstate,'color',t.Private,'subset',t.Top10perc>50); % subset command graphs only a subset of data
g(1,3).set_title('Elite Colleges');
g(1,3).stat_violin('normalization','width','half',0,'dodge',0,'fill','transparent')
g(1,3).stat_boxplot('width',.2);
g(1,3).axe_property('LineWidth',1.5,'FontSize',12);
g(1,3).set_names('x','Private','y','Out of State Students','color',{});
g(1,3).no_legend();

g.draw % Actually draws the figure after setup
g.export('file_name','Plotting College Data with Gramm','file_type','png');

%% Looking at just ELITE Colleges...
% Elite = t(colleges where the top 10% of their high school classes exceeds 50% , All Columns)
Elite=t(t.Top10perc>50,:);

% Lets compare Room and Board costs inprivate and public ELITE colleges 
% with different distribution techniques...
g(1,1)=gramm('x',t.Room_Board,'color',t.Private);
g(1,1).set_names('x','Room and Board Cost ($)','color','Private');
g(1,2)=copy(g(1));
g(1,3)=copy(g(1));
g(2,1)=copy(g(1));
g(2,2)=copy(g(1));
g(2,3)=copy(g(1));

%Default binning (30 bins)
g(1,1).stat_bin('geom','overlaid_bar'); 
g(2,1).set_title('default');
%Normalization to 'probability'
g(2,1).stat_bin('normalization','probability','geom','overlaid_bar');
g(2,1).set_title('probability','FontSize',10);

%Normalization to cumulative count
g(1,2).stat_bin('normalization','cumcount','geom','stairs');
g(1,2).set_title('cumcount','FontSize',10);

%Normalization to cumulative density
g(2,2).stat_bin('normalization','cdf','geom','stairs');
g(2,2).set_title('cdf','FontSize',10);

%Custom edges for the bins
g(1,3).stat_bin('edges',0:100:10000,'geom','overlaid_bar');
g(1,3).set_title('''edges'',-1:0.5:10','FontSize',10);

%Custom edges with non-constand width (normalization 'countdensity' recommended)
g(2,3).stat_bin('geom','overlaid_bar','normalization','countdensity','edges',[0 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000]);
g(2,3).set_title('''countdensity'',''custom edges''','FontSize',10);

% Finalize the figure, draw and export it
g.set_title('Some Options for stat_bin()');
figure('Position',[100 100 800 600]);
g.draw();
g.export('file_name','Stat Bin Options','file_type','png');




