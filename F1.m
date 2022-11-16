
%parametros
ma=740; %Masa del F1
cf=0.68; %Coeficiente de friccion
A = 1.5;%Area transversal 
Da= 1.225; %Densidad del aire 
%Valores iniciales
cp1=0;
cp2=0;%Calor perdido
v=10;%velocidad inicial
a=0;%aceleracion inicial
xp=100;%Pocicion en x inicial

%Fuerzas Motor
Fm= 5000; %Fuerza motor inicial
Fma= 5000; %Fuerza motor acelerando
Fmf=-1*Fma; %Fuerza motor desacelerando

Ff=0;%Fuerza friccion inicial
t=linspace(0,100,10000);


%Formulas distancia
st=100;%limite menor
n=1000;%numero de intervalos
m=@(x) (-0.0000028608*(x^2)+0.007932*(x)-4.305);
f=@(x) sqrt(1+m(x)^2);

%Figura
figure(1);
hold on
grid on
axis([min(0) max(3000) min(0) max(3000)]);

%Camino
x=linspace(100,2800,100000);
y=(-0.0000009536*(x.^3)+0.003966*(x.^2)-4.305*(x)+2091.79);
plot(x,y,'-r','LineWidth',9);
plot(x,y,'-k','LineWidth',8);
plot(x,y,'--w','LineWidth',1);


%Gradas
gradas1= rectangle('Position', [340 391 800 100],'FaceColor','yellow');
gradas2= rectangle('Position', [1632 1920 800 100],'FaceColor','yellow');

for i=1:100000
%Movimiento F1
    angulo=atan(m(xp));
    Fa=.5*Da*v^2*A; %Fuerza de arrastre
    a= (Fm-Fa-Ff)/ma; %Aceleracion
    v=v+(a*0.01); %Velocidad
    xp=xp+((v*cos(angulo))*0.01); %Posicion en x
    yp=(-0.0000009536*(xp^3)+0.003966*(xp^2)-4.305*(xp)+2091.79); %Posicion en y
    F1=plot(xp,yp,'sw','MarkerSize',7);
%Ecuaciones tangentes en posibles puntos de derrape
    yd1=(-1.65*(xp)+1604.94);
    yd2=(1.07*(xp)-253.69);
    

%Aceleracion del motor en curva
    if (xp>300) && (xp<305) %Dejar de acelerar 50m antes de la curva
        Fm=0;
    elseif (xp>1000) && (xp<1005) %Acelerar saliendo de la curva
        Fm=Fma;
    elseif (xp>1350) && (xp<1355) %Dejar de acelerar 50m antes de la curva
        Fm=0;
    elseif (xp>2200)  %Acelerar saliendo de la curva
        Fm=Fma;
    end

%Derrape en puntos criticos
    if (Ff>0) && (xp>405)
        delete(F1); 
        F1=plot(xp,yd1,'sw','MarkerSize',7,'Color','red');
        cp1=sqrt(((xp-x1)^2)+(yd1-y1));
    elseif (xp>400) && (xp<405) && (v>43) 
        Ff=cf*9.8*ma;
        x1=xp;
        y1=yp;
    end
    if (xp>1600) && (xp<1605) && (v>43) 
        Ff=cf*9.8*ma;  
        x1=xp;
        y1=yp;
    elseif (Ff>0) && (xp>1605)          
        F1=plot(xp,yd2,'sw','MarkerSize',7,'Color','red');
        
        cp2=sqrt(((xp-x1)^2)+(yd2-y1));
    end    
%Recorrido   
    x=linspace(a,xp,n+1);
    n=length(x);    
    Longitud=(f(x(1))+f(x(n)))/2;
    for i=2:n-1
        Longitud=Longitud+f(x(i));
    end
    Longitud=Longitud*(x(2)-x(1));
    
    

%Indices
    %Posicion
    txt = ['Posicion en x: ',num2str(xp)];
    tpx=text(2000,2900,txt);
    txt = ['Posicion en y: ',num2str(yp)];
    tpy=text(2000,2800,txt);
    %Fuerza de arrastre
    txt = ['Fd: -',num2str(Fa),'N'];
    tfd=text(50,2650,txt);
    %Velocidad
    txt = ['V: ',num2str(v*3.6),'Km/h'];
    tv=text(50,2900,txt);
    %Aceleracion 
    txt = ['Aceleracion: ',num2str(a),'ms^2'];
    ta=text(50,2800,txt);
    %Tiempo
    txt = ['Tiempo: ',num2str(t(i)),'s'];
    tt=text(2000,2650,txt);
    %Perdida de enrgia en calor
    txt = ['Perdida de enrgia en calor: ',num2str(((cp1+cp2)*Ff)/1000),'kJ'];
    twf=text(50,2550,txt);
    %Distancia
    txt = ['Distancia Recorrida: ',num2str(Longitud/1000),'Km'];
    tdis=text(2000,2550,txt);    

%Breaks    
    if xp>2800
        break
    elseif v<0
        
        break
    end
%Deletes
    pause(0.0000001);
    delete(tpx);
    delete(tpy);
    delete(tfd);
    delete(tv);
    delete(tt);
    delete(ta);
    delete(F1);
    delete(twf);
    delete(tdis);
end