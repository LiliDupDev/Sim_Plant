/***
* Name: Emulation
* Author: Lili
* Description: 
* Tags: Tag1, Tag2, TagN
***/

model Emulation

//variables globales
global
{ 	//variables
	float suma<-1.0;
	float vel_proteina<-0.005;
	point mypoint;
	int cantidad<-rnd(1,11);
	float cont<-0.0;
	bool stop<-false;
	int cuenta<-10; 
	float level_step <- 0.8;
	float length_max <- 100.0;

	//*******************************************************************************************************
	bool trace <-false;
	int cant_plant<-5 category:'Ambiente';
	//***********************Menu PLantas********************************************************************
	string tipoplant<-"Maiz" among:["Maiz","Lechuga"] category:'Planta';
	float edad<-0.0;
	int phplant parameter:'PH'min: 0 max: 14<-7  category:'Planta';
	float timelive <-0.0 category:'Planta';
	float timeflor<-0.0 category:'Planta';
    float tempmin<-0.0 category: 'Planta';
	float tempmax<-0.0 category: 'Planta';
	int   lightmin <- 2000 category:'Planta';
	int   lightmax <- 7000 category:'Planta';
	float number_of_agents parameter: 'Velocidad de crecimiento' min: 1.0 <- 250.0 step:10 category: 'Planta'; //asignas a una categoria de parametros
	
	//***********************************subcategoria*******************************************************
	float cant_Nitrogeno_plant<-14.5   category:'Necesidades Nutricionales';
	float cant_Fosforo_plant<-3.0     category:'Necesidades Nutricionales';
	float cant_Potasio_plant<-4.0     category:'Necesidades Nutricionales';
	float cant_Calcio_plant<-0.2      category:'Necesidades Nutricionales';
	float cant_Magnesio_plant<-0.8    category:'Necesidades Nutricionales';
	float cant_Azufre_plant<-1.8      category:'Necesidades Nutricionales';
	float cant_Boro_plant<-5.0        category:'Necesidades Nutricionales';
	float cant_Cobre_plant<-4.0       category:'Necesidades Nutricionales';
	float cant_Hierro_plant<-45.0      category:'Necesidades Nutricionales';
	float cant_Manganeso_plant<-32.0   category:'Necesidades Nutricionales';
	float cant_Molibdeno_plant<-1.0   category:'Necesidades Nutricionales';
	float cant_Zinc_plant<-27.0        category:'Necesidades Nutricionales';
	//***********************************Menu Biomasa********************************************************
	
	string typebio<-"Tierra" among:[ "Liquida", "Tierra"] category:'Biomasa';
	float h_biomass <- 50.0;	//LD
	bool flgStartWater <- false;//LD
    int humedabio<-20       category:'Biomasa';
	float cant_Nitrogeno<-22.0  category:'Biomasa';
	float cant_Fosforo<-4.0    category:'Biomasa';
	float cant_Potasio<-19.0    category:'Biomasa';
	float cant_Calcio<-3.0     category:'Biomasa';
	float cant_Magnesio<-3.0   category:'Biomasa';
	float cant_Azufre<-4.0     category:'Biomasa';
	float cant_Boro<-20.0       category:'Biomasa';
	float cant_Cobre<-13.0      category:'Biomasa';
	float cant_Hierro<-125.0     category:'Biomasa';
	float cant_Manganeso<-189.0  category:'Biomasa';
	float cant_Molibdeno<-1.0  category:'Biomasa';
	float cant_Zinc<-53.0       category:'Biomasa';
	int ph parameter:'PH'min: 0 max: 14<-7  category:'Biomasa';
	//string agentAspect <- "Potasio" among:["Calcio","Magnesio","Nitrogeno", "Sulduro","Potasio"] category: 'Biomasa';
	
	/* ============= Environment ============== */
	float temp_env 		<- 20.0 	category:'Ambiente';
	float airFlow_env 	<- 2.5 		category:'Ambiente';
	float humidity_env 	<- 26.0 	category:'Ambiente';
	int light_env 		<- 2000 	category:'Ambiente';
	bool fertilizar 	<- true;
	
	/*Database connection ============================================================================*/
	string server 	<-'' category:'Base de datos';
	string dbType 	<-'MySQL' among:[ "MySQL", "Postgres","SQLite","SQLServer"] category:'Base de datos';
	string database <-'' category:'Base de datos';
	string port 	<-'' category:'Base de datos';
	string user 	<-'' category:'Base de datos';
	string password <-'' category:'Base de datos';
	//map<string,string> PARAMS <- ['host'::'localhost','dbtype'::'MySQL','database'::'simplant',
	//			                  'port'::'3306','user'::'root','passwd'::''];
    map<string,string> PARAMS <- ['host'::server,'dbtype'::dbType,'database'::database,
				                  'port'::port,'user'::user,'passwd'::password];
	string query <- 'select distinct 
						temp.nTemperature 	nTemperature,
						flow.nflow 			nFlow,
				        hum.nmeasure 		nHumidity,
				        light.nmeasure 		nLight
				from 		simplant.environment 	env
				inner join 	simplant.sensor 		sen on env.idenvironment = sen.idenvironment
				inner join 	(select idsensor, nTemperature  from simplant.temperature order by dMeasure desc limit 1) as temp on temp.idsensor = sen.idsensor
				left join 	(select idsensor, nflow  from simplant.airflow order by dMeasure desc limit 1) as flow on flow.idsensor = sen.idsensor
				left join 	(select idsensor, nmeasure  from simplant.humidity order by dMeasure desc limit 1) as hum on hum.idsensor = sen.idsensor
				left join 	(select idsensor, nmeasure  from simplant.light order by dMeasure desc limit 1) as light on light.idsensor = sen.idsensor';
	/* ============================================================================================== */
	
	//*******************************************************************************************************
	//inicializas los agentes
	init
	{  
	create environment number:1;
	create Nitrogeno number:cant_Nitrogeno
	{
		location<-{rnd(2,90),rnd(80,100),7};
		
	}
    create Fosforo number:cant_Fosforo
	{
		location<-{rnd(2,90),rnd(80,100),7};
		
	}
	create Potasio number:cant_Potasio
	{
		location<-{rnd(2,90),rnd(80,100),5};
		
	}
	create Magnesio number:cant_Magnesio
	{
		location<-{rnd(2,90),rnd(80,100),6};
		
	}
	create Calcio number:cant_Calcio
	{
		location<-{rnd(2,90),rnd(80,100),7};
		
	}
	create Azufre number:cant_Azufre
	{
		location<-{rnd(2,90),rnd(80,100),7};
		
	}
	create Boro number:cant_Boro
	{
		location<-{rnd(2,90),rnd(80,100),7};
		
	}
	create Cobre number:cant_Cobre
	{
		location<-{rnd(2,90),rnd(80,100),7};
	
	}
	create Hierro number:cant_Hierro
	{
		location<-{rnd(2,90),rnd(80,100),7};
		
	}
	create Manganeso number:cant_Manganeso
	{
		location<-{rnd(2,90),rnd(80,100),7};
		
	}
	create Molibdeno number:cant_Molibdeno
	{
		location<-{rnd(2,90),rnd(80,100),7};
		
	}
	create Zinc number:cant_Zinc
	{
		location<-{rnd(2,90),rnd(80,100),7};
		
	}

	create planta number:cant_plant
		{
			if(cant_plant=1)
			{
				location<-{50,70,5};
			}
			else
			{
					location<-{rnd(2,90),70,5};
			}
		
			mypoint<-{location.x,75,5};
		}

	create arcilla{} //LD
	create biomass
		{
			location<-{50,100,4};
			aa<-rectangle(100,50);
            liq<-rgb(120,60,0);
		}
	}
	reflex stop when:cont>101{
		do pause;
	}
	
}

/* ============= Environment ============= */
species DB_Accesor skills: [SQLSKILL];

species environment{
	float temperature;
	float humidity;
	float airFlow;
	float light;
	int contAccess<-0;
	
	reflex update  
	{
		contAccess<-contAccess+1;
		if mod(contAccess,100)=0
		{
			PARAMS <- ['host'::server,'dbtype'::dbType,'database'::database,
				                  'port'::port,'user'::user,'passwd'::password];
			create DB_Accesor{
				if(testConnection(params:PARAMS))
				{
					create environment from: list(select(params:PARAMS, select:query)) with:[temperature::"nTemperature",humidity::"nHumidity",airFlow::"nFlow",light::"nLight"];
			
					loop a_temp_var over: environment { 
					     temp_env <- a_temp_var.temperature;
					     airFlow_env <- a_temp_var.airFlow;
						 humidity_env <- a_temp_var.humidity;
						 light_env <- a_temp_var.light;
					}
					
				}
				else{write "No connection";}
				
			}
		}
		
	}
}
/* =========================================== */

//agente planta
species planta
{ //importar imagenes
float size <- 8.0;
	bool lowTemp <-false;
	bool highTemp<-false;
	bool highHumidity <-false;
	bool lowHumidity <-false;
	bool highFlow <-false;
	bool lowFlow<-false;
	bool highLight<-false;
	bool lowLight<-false;
	int cont_plant <- 0;
	
	
	image_file maizstep1<-file("../images/sem0.png");
	image_file lechugastep<-file("../images/sem0.png");
	float level <- 1.0;
	float beta <- 0.0;
	float alpha <- 0.0;
	planta parent <- nil;
	point base <- {0, 0, 0};
	point end <- {0, 0, 0};
	int id;
	//su astpecto o forma
	aspect default 
	{if(tipoplant="Maiz")
		{
			draw maizstep1 size:2*size;
		}
		else if(tipoplant="Lechuga")
		{
			draw lechugastep size:2*size;
		}
		
	
		
		
		
	}
	reflex growth when: stop=false
	{
		if temp_env > tempmax
		{
			highTemp<-true;
		}
		else if temp_env < tempmin
		{
			lowTemp<-true;
		}
		else
		{
			highTemp<-false;
			lowTemp<-false;
		}
		
		if airFlow_env > 2.5
		{
			highFlow<-true;
		}
		else if airFlow_env<1.8
		{
			highTemp<-true;
		}
		else
		{
			highFlow<-false;
		}
		
		if light_env > lightmax
		{
			highLight<-true;
		}
		else if light_env > lightmin
		{
			lowLight<-true;
		}
		else
		{
			highLight<-false;
			lowLight<-false;
		}
	}
	reflex crese when:cont_plant>10 and cont_plant<20// and Potasio location:{12,12,12}
	{
		if(tipoplant="Maiz")
		{
			maizstep1<-file("../images/sem1.png");
	 	float logCont<-log(cont_plant);
		if logCont<0
		{
			logCont<-logCont*-1;
		}
		float edad_aux<-(timelive/7)+logCont;
		edad <- edad_aux;

		}
		else if(tipoplant="Lechuga")
		{
			lechugastep<-file("../images/lechuga1.png");
		}
		
	 
	}
	reflex crese2 when:cont_plant>20 and cont_plant<40
	{
		if(tipoplant="Maiz")
		{
			string imagename<-"../images/sem2.png";
		if highTemp
		{
			imagename<-"../images/altaTemp_1.png";
		}
		else if highLight
		{
			imagename<-"../images/altaLuz_1.png";
		}
		else if lowTemp
		{
			imagename<-"../images/bajaTemp_1.png";
		}
		else if lowLight
		{
			imagename<-"../images/bajaLuz_1.png";
		}
		
		maizstep1<-file(imagename);
		float logCont<-log(cont_plant);
		if logCont<0
		{
			logCont<-logCont*-1;
		}
		float edad_aux<-2*(timelive/7)+logCont;
		edad <- edad_aux;
		}
		else if(tipoplant="Lechuga")
		{
			lechugastep<-file("../images/lechuga1.png");
		}
		
	
	}
	reflex crese3 when:cont_plant>40 and cont_plant<50
	{
		if(tipoplant="Maiz")
		{
			 
		string imagename<-"../images/sem3.png";
		if highTemp
		{
			imagename<-"../images/altaTemp_2.png";
		}
		else if highLight
		{
			imagename<-"../images/altaLuz_2.png";
		}
		else if lowTemp
		{
			imagename<-"../images/bajaTemp_2.png";
		}
		else if lowLight
		{
			imagename<-"../images/bajaLuz_2.png";
		}
		size<-11.0;
		maizstep1<-file(imagename);
		float logCont<-log(cont_plant);
		if logCont<0
		{
			logCont<-logCont*-1;
		}
		float edad_aux<-3*(timelive/7)+logCont;
		edad <- edad_aux;
		}
		else if(tipoplant="Lechuga")
		{
			lechugastep<-file("../images/lechuga2.png");
		}
		
	//location<-{50,69,5};
	
	
	}
	reflex crese4 when:cont_plant>50 and cont_plant<60
	{if(tipoplant="Maiz")
		{
		string imagename<-"../images/sem4.png";
		if highTemp
		{
			imagename<-"../images/altaTemp_3.png";
		}
		else if highLight
		{
			imagename<-"../images/altaLuz_3.png";
		}
		else if lowTemp
		{
			imagename<-"../images/bajaTemp_3.png";
		}
		else if lowLight
		{
			imagename<-"../images/bajaLuz_3.png";
		}
		
		size<-14.5; 
		maizstep1<-file(imagename);
		float logCont<-log(cont_plant);
		if logCont<0
		{
			logCont<-logCont*-1;
		}
		float edad_aux<-3*(timelive/7)+logCont;
		edad <- edad_aux;
		}
		else if(tipoplant="Lechuga")
		{
			lechugastep<-file("../images/lechuga3.png");
		}
		
	//location<-{50,69,5}; 
	
	}
	reflex crese5 when:cont_plant>60 and cont_plant<70
	{if(tipoplant="Maiz")
		{
		string imagename<-"../images/sem5.png";
		if highTemp
		{
			imagename<-"../images/altaTemp_4.png";
		}
		else if highLight
		{
			imagename<-"../images/altaLuz_4.png";
		}
		else if lowTemp
		{
			imagename<-"../images/bajaTemp_4.png";
		}
		else if lowLight
		{
			imagename<-"../images/bajaLuz_4.png";
		}
		
		size<-22.0;
		maizstep1<-file(imagename);
		float logCont<-log(cont_plant);
		if logCont<0
		{
			logCont<-logCont*-1;
		}
		float edad_aux<-4*(timelive/7)+logCont;
		edad <- edad_aux;
		}
		else if(tipoplant="Lechuga")
		{
			lechugastep<-file("../images/lechuga4.png");
		}
		
	//location<-{50,68,5}; 
	 
	}
	reflex mature when:cont_plant>70 and cont_plant<80
	{
		if(tipoplant="Maiz")
		{ 
		string imagename<-"../images/sem6.png";
		if highTemp
		{
			imagename<-"../images/altaTemp_4.png";
		}
		else if highLight
		{
			imagename<-"../images/altaLuz_4.png";
		}
		else if lowTemp
		{
			imagename<-"../images/bajaTemp_4.png";
		}
		else if lowLight
		{
			imagename<-"../images/bajaLuz_4.png";
		}
		
		maizstep1<-file(imagename);
		float logCont<-log(cont_plant);
		if logCont<0
		{
			logCont<-logCont*-1;
		}
		float edad_aux<-5*(timelive/7)+logCont;
		edad <- edad_aux;
		}
		else if(tipoplant="Lechuga")
		{
			lechugastep<-file("../images/lechuga5.png");
		}
		
	// location<-{50,68,5}; 
	
	}
	reflex die when:cont_plant>100
	{  
		 if(tipoplant="Maiz")
		{
		float logCont<-log(cont_plant);
		if logCont<0
		{
			logCont<-logCont*-1;
		}
		float edad_aux<-6*(timelive/7)+logCont;
		edad <- edad_aux;
		maizstep1<-file("../images/sem7.png");
		}
		else if(tipoplant="Lechuga")
		{
				lechugastep<-file("../images/lechuga5.png");
		}
	
	//location<-{50,68,5};
	stop<-true;
	}
	
}


//esta es la tierra no la biomasa
species arcilla
{
	geometry appereance;
	aspect default
	{
		draw appereance color: rgb(120,60,0);
	}
	reflex appears  when: typebio="Liquida"
	{	
		location<-{50,77,0};
	    appereance <-rectangle(100,5);
	}
}

species biomass 
{image_file floor<-file("../images/tierra.jpg");
	geometry aa;
	rgb liq;
	

	
	aspect default
	{		
         draw floor size:{100,50};        	
		//draw aa color: liq;
	         
	   
	}
	
	reflex a  when: typebio="Liquida"
	{liq<-rgb(212,234,237);
	        aa<-rectangle(100,50);
	         
	            
	}
}


//particulas para la biomasa
species Nitrogeno skills:[moving] parent: biomass 
{//point punto;
	point punto;
agent target <- nil;
reflex target when: target = nil {
		float min_distance <- #infinity;
		float min_temp <- 0.0;	
		
		list<agent> plantas <- agents of_species planta;
		
		loop myplanta over: plantas{			
			min_temp <- location distance_to myplanta.location ;			
				if (min_temp < min_distance){
					target <- myplanta;
					min_distance <- min_temp; 
					
				}	
				
				punto<-{target.location.x,75,target.location.z};
						
		}	
			

	}
	reflex consumir when: punto=location
	{
	 
				list<planta> plants <- planta where (each distance_to self <= 5.0);
			ask plants
			{
				float consumption<-cant_Nitrogeno_plant/cant_plant;
				cont_plant<-cont_plant + consumption;
			}
			cant_Nitrogeno <- cant_Nitrogeno - cant_Nitrogeno_plant/cant_plant; //LD
					do die;
				
	}

reflex goto when: typebio="Tierra"{
		//mypoint<-{rnd(12),rnd(12),rnd(12)};
		if (target != nil){
			do goto target: punto speed: vel_proteina;
		
			
		}
		if(mypoint = location){
			
			cont <- cont + suma;
			do die;			
		}
	}

	aspect default
	{
		if(typebio="Tierra"){
		draw circle(1) color:(cantidad>0)?#blue:#blue border: #darkgreen;
			//draw "N"color:#black size:1;
			}
	}
	/*reflex goto when: typebio="Tierra"{
		//mypoint<-{rnd(12),rnd(12),rnd(12)};
		do goto target: mypoint speed:vel_proteina;
		if(mypoint=location)
		{cont<-cont+suma;
			do die;
			
		}
	}*/
 
}
species Fosforo skills:[moving] parent: biomass
{
	point punto;
	agent target <- nil;
	reflex target when: target = nil {
		float min_distance <- #infinity;
		float min_temp <- 0.0;	
		
		list<agent> plantas <- agents of_species planta;
		
		loop myplanta over: plantas{			
			min_temp <- location distance_to myplanta.location ;			
				if (min_temp < min_distance){
					target <- myplanta;
					min_distance <- min_temp; 
				}	
				
				punto<-{target.location.x,75,target.location.z};	
		}		

	}
	aspect default
	{
		if(typebio="Tierra"){
		draw circle(1) color:(cantidad>0)?#aqua:#blue border: #darkgreen;
			//draw "F"color:#black size:1;
			}
	}
	reflex consumir when: punto=location
	{
					list<planta> plants <- planta where (each distance_to self <= 5.0);
			ask plants
			{
				float consumption <-  cant_Fosforo_plant/cant_plant;
				cont_plant<-cont_plant +consumption;
			}
			cant_Fosforo <- cant_Fosforo - cant_Fosforo_plant/cant_plant; //LD
			do die;
					}
	reflex goto when: typebio="Tierra"{
		//mypoint<-{rnd(12),rnd(12),rnd(12)};
		if (target != nil){
			do goto target: punto speed: vel_proteina;
		}
		
		if(mypoint = location){
			
			
			cont <- cont + suma;
			do die;			
		}
	}

}

species Potasio skills:[moving] parent: biomass
{
	point punto;
agent target <- nil;
reflex target when: target = nil {
		float min_distance <- #infinity;
		float min_temp <- 0.0;	
		
		list<agent> plantas <- agents of_species planta;
		
		loop myplanta over: plantas{			
			min_temp <- location distance_to myplanta.location ;			
				if (min_temp < min_distance){
					target <- myplanta;
					min_distance <- min_temp; 
				}
				
				punto<-{target.location.x,75,target.location.z};		
		}		

	}
	aspect default
	{
		if(typebio="Tierra"){
		draw circle(1) color:(cantidad>0)?#green:#blue border: #darkgreen;
			//draw "P"color:#black size:1;
			}
	}
	reflex consumir when: punto=location
	{
					list<planta> plants <- planta where (each distance_to self <= 5.0);
			ask plants
			{
				float consumption <- cant_Potasio_plant/cant_plant;
				cont_plant <- cont_plant+consumption;
			}
			cant_Potasio <- cant_Potasio - cant_Potasio_plant/cant_plant; //LD
			do die;
					}
	reflex goto when: typebio="Tierra"{
		//mypoint<-{rnd(12),rnd(12),rnd(12)};
		if (target != nil){
			do goto target: punto speed: vel_proteina;
		}
		
		if(mypoint = location){
			
			cont <- cont + suma;
			do die;			
		}
	}

}
species Calcio skills:[moving]parent: biomass
{ point punto;
agent target <- nil;
reflex target when: target = nil {
		float min_distance <- #infinity;
		float min_temp <- 0.0;	
		
		list<agent> plantas <- agents of_species planta;
		
		loop myplanta over: plantas{			
			min_temp <- location distance_to myplanta.location ;			
				if (min_temp < min_distance){
					target <- myplanta;
					min_distance <- min_temp; 
				}
				
				
				
				punto<-{target.location.x,75,target.location.z};		
		}		

	}
	geometry a;
	aspect default
	{if(typebio="Tierra"){
			draw circle(1) color:(cantidad>0)?#yellow:#blue border: #black;
			//draw "C"color:#black size:1;	
	}}
	reflex consumir when: punto=location
	{
		
					list<planta> plants <- planta where (each distance_to self <= 5.0);
			ask plants
			{
				float consumption <- cant_Calcio_plant/cant_plant;
				cont_plant<-cont_plant+consumption;
			}
			cant_Calcio <- cant_Calcio - cant_Calcio_plant/cant_plant; //LD
			do die;
				
	}
	reflex goto when: typebio="Tierra"{
		//mypoint<-{rnd(12),rnd(12),rnd(12)};
		if (target != nil){
			do goto target: punto speed: vel_proteina;
		}
		
		if(mypoint = location){
			
			cont <- cont + suma;
			do die;			
		}
	}
	
}
species Magnesio skills:[moving] parent: biomass
{point punto;
agent target <- nil;
reflex target when: target = nil {
		float min_distance <- #infinity;
		float min_temp <- 0.0;	
		
		list<agent> plantas <- agents of_species planta;
		
		loop myplanta over: plantas{			
			min_temp <- location distance_to myplanta.location ;			
				if (min_temp < min_distance){
					target <- myplanta;
					min_distance <- min_temp; 
				}
				
				punto<-{target.location.x,75,target.location.z};		
		}		

	}
	aspect default
	{	if(typebio="Tierra"){
		draw circle(1) color:(cantidad>0)?#brown:#blue border: #black;
			//draw "M"color:#black size:1;	
		}	
	}
	reflex consumir when: punto=location
	{
					list<planta> plants <- planta where (each distance_to self <= 5.0);
			ask plants
			{
				float consumption <-  cant_Magnesio_plant/cant_plant;
				cont_plant<-cont_plant+consumption;
			}
			cant_Magnesio <- cant_Magnesio - cant_Magnesio_plant/cant_plant; //LD
			do die;
					}
	reflex goto when: typebio="Tierra"{
		//mypoint<-{rnd(12),rnd(12),rnd(12)};
		if (target != nil){
			do goto target: punto speed: vel_proteina;
		}
		
		if(mypoint = location){
			cont <- cont + suma;
			do die;			
		}
	}
	
}
species Azufre skills:[moving] parent: biomass
{point punto;
agent target <- nil;
	reflex target when: target = nil {
		float min_distance <- #infinity;
		float min_temp <- 0.0;	
		
		list<agent> plantas <- agents of_species planta;
		
		loop myplanta over: plantas{			
			min_temp <- location distance_to myplanta.location ;			
				if (min_temp < min_distance){
					target <- myplanta;
					min_distance <- min_temp; 
				}	
				
				punto<-{target.location.x,75,target.location.z};		
		}		

	}
	aspect default
	{
		if(typebio="Tierra"){
		draw circle(1) color:(cantidad>0)?#pink:#blue border: #darkgreen;
			//draw "A"color:#black size:1;
			}
	}
	reflex consumir when: punto=location
	{
					list<planta> plants <- planta where (each distance_to self <= 5.0);
			ask plants
			{
				float consumption <- cant_Azufre_plant/cant_plant;
				cont_plant<-cont_plant+consumption;
			}
			cant_Azufre <- cant_Azufre - cant_Azufre_plant/cant_plant; //LD
			do die;
				}
	reflex goto when: typebio="Tierra"{
		//mypoint<-{rnd(12),rnd(12),rnd(12)};
		if (target != nil){
			do goto target: punto speed: vel_proteina;
		}
		
		if(mypoint = location){
			cont <- cont + suma;
			do die;			
		}
	}

}
species Boro skills:[moving] parent: biomass
{
	point punto;
agent target <- nil;
reflex target when: target = nil {
		float min_distance <- #infinity;
		float min_temp <- 0.0;	
		
		list<agent> plantas <- agents of_species planta;
		
		loop myplanta over: plantas{			
			min_temp <- location distance_to myplanta.location ;			
				if (min_temp < min_distance){
					target <- myplanta;
					min_distance <- min_temp; 
				}
				
				punto<-{target.location.x,75,target.location.z};		
		}		

	}
	aspect default
	{
		if(typebio="Tierra"){
		draw circle(1) color:(cantidad>0)?#white:#blue border: #darkgreen;
			//draw "B"color:#black size:1;
			}
	}
	reflex consumir when: punto=location
	{
					list<planta> plants <- planta where (each distance_to self <= 5.0);
			ask plants
			{
				float consumption <- cant_Boro_plant/cant_plant;
				cont_plant<-cont_plant+consumption;
			}
			cant_Boro <- cant_Boro - cant_Boro_plant/cant_plant; //LD
			do die;
					}
reflex goto when: typebio="Tierra"{
		//mypoint<-{rnd(12),rnd(12),rnd(12)};
		if (target != nil){
			do goto target: punto speed: vel_proteina;
		}
		
		if(mypoint = location){
			
			cont <- cont + suma;
			do die;			
		}
	}

}
species Cobre skills:[moving] parent: biomass
{point punto;
agent target <- nil;
	reflex target when: target = nil {
		float min_distance <- #infinity;
		float min_temp <- 0.0;	
		
		list<agent> plantas <- agents of_species planta;
		
		loop myplanta over: plantas{			
			min_temp <- location distance_to myplanta.location ;			
				if (min_temp < min_distance){
					target <- myplanta;
					min_distance <- min_temp; 
				}	
				
				punto<-{target.location.x,75,target.location.z};		
		}		

	}
	aspect default
	{
		if(typebio="Tierra"){
		draw circle(1) color:(cantidad>0)?#magenta:#blue border: #darkgreen;
			//draw "C"color:#black size:1;
			}
	}
	reflex consumir when: punto=location
	{
					list<planta> plants <- planta where (each distance_to self <= 5.0);
			ask plants
			{
				float consumption <- cant_Cobre_plant/cant_plant;
				cont_plant<-cont_plant+consumption;
			}
			cant_Cobre <- cant_Cobre - cant_Cobre_plant/cant_plant; //LD
			do die;
				
			}
	reflex goto when: typebio="Tierra"{
		//mypoint<-{rnd(12),rnd(12),rnd(12)};
		if (target != nil){
			do goto target: punto speed: vel_proteina;
		}
		
		if(mypoint = location){
			cont <- cont + suma;
			do die;			
		}
	}

}
species Hierro skills:[moving] parent: biomass
{point punto;
agent target <- nil;
	reflex target when: target = nil {
		float min_distance <- #infinity;
		float min_temp <- 0.0;	
		
		list<agent> plantas <- agents of_species planta;
		
		loop myplanta over: plantas{			
			min_temp <- location distance_to myplanta.location ;			
				if (min_temp < min_distance){
					target <- myplanta;
					min_distance <- min_temp; 
				}	
					
				punto<-{target.location.x,75,target.location.z};	
		}		

	}
	aspect default
	{
		if(typebio="Tierra"){
		draw circle(1) color:(cantidad>0)?#purple:#blue border: #darkgreen;
			//draw "H"color:#black size:1;
			}
	}
	reflex consumir when: punto=location
	{
					list<planta> plants <- planta where (each distance_to self <= 5.0);
			ask plants
			{
				float consumption <- cant_Hierro_plant/cant_plant;
				cont_plant<-cont_plant+consumption;
			}
			cant_Hierro <- cant_Hierro - cant_Hierro_plant/cant_plant; //LD
			do die;
				}
reflex goto when: typebio="Tierra"{
		//mypoint<-{rnd(12),rnd(12),rnd(12)};
		if (target != nil){
			do goto target: punto speed: vel_proteina;
		}
		
		if(mypoint = location){
			cont <- cont + suma;
			do die;			
		}
	}

}
species Manganeso skills:[moving] parent: biomass
{
	point punto;

	agent target <- nil;
	reflex target when: target = nil {
		float min_distance <- #infinity;
		float min_temp <- 0.0;	
		
		list<agent> plantas <- agents of_species planta;
		
		loop myplanta over: plantas{			
			min_temp <- location distance_to myplanta.location ;			
				if (min_temp < min_distance){
					target <- myplanta;
					min_distance <- min_temp; 
				}
				
				punto<-{target.location.x,75,target.location.z};			
		}		

	}
	aspect default
	{
		if(typebio="Tierra"){
		draw circle(1) color:(cantidad>0)?#black:#blue border: #darkgreen;
			//draw "Ma"color:#black size:1;
			}
	}
	reflex consumir when: punto=location
	{
					list<planta> plants <- planta where (each distance_to self <= 5.0);
			ask plants
			{
				float consumption <- cant_Manganeso_plant/cant_plant;
				cont_plant<-cont_plant+consumption;
			}
			cant_Manganeso <- cant_Manganeso - cant_Manganeso_plant/cant_plant; //LD
			do die;
				}
	reflex goto when: typebio="Tierra"{
		//mypoint<-{rnd(12),rnd(12),rnd(12)};
		if (target != nil){
			do goto target: punto speed: vel_proteina;
		}
		
		if(mypoint = location){
			cont <- cont + suma;
			do die;			
		}
	}

}
species Molibdeno skills:[moving] parent: biomass
{
point punto;
	agent target <- nil;
	reflex target when: target = nil {
		float min_distance <- #infinity;
		float min_temp <- 0.0;	
		
		list<agent> plantas <- agents of_species planta;
		
		loop myplanta over: plantas{			
			min_temp <- location distance_to myplanta.location ;			
				if (min_temp < min_distance){
					target <- myplanta;
					min_distance <- min_temp; 
				}
				
				punto<-{target.location.x,75,target.location.z};			
		}		

	}
	aspect default
	{
		if(typebio="Tierra"){
		draw circle(1) color:(cantidad>0)?#orange:#blue border: #darkgreen;
			//draw "M"color:#black size:1;
			}
	}
	reflex consumir when: punto=location
	{
					list<planta> plants <- planta where (each distance_to self <= 5.0);
			ask plants
			{
				float consumption <- cant_Molibdeno_plant/cant_plant;
				cont_plant<-cont_plant+consumption;
			}
			cant_Molibdeno <- cant_Molibdeno - cant_Molibdeno_plant/cant_plant; //LD
			do die;
				}
	reflex goto when: typebio="Tierra"{
		//mypoint<-{rnd(12),rnd(12),rnd(12)};
		if (target != nil){
			do goto target: punto speed: vel_proteina;
		}
		
		if(mypoint = location){
			cont <- cont + suma;
			do die;			
		}
	}

}
species Zinc skills:[moving] parent: biomass
{
	point punto;
agent target <- nil;
reflex target when: target = nil {
		float min_distance <- #infinity;
		float min_temp <- 0.0;	
		
		list<agent> plantas <- agents of_species planta;
		
		loop myplanta over: plantas{			
			min_temp <- location distance_to myplanta.location ;			
				if (min_temp < min_distance){
					target <- myplanta;
					min_distance <- min_temp; 
				}
				
				punto<-{target.location.x,75,target.location.z};			
		}		

	}
	aspect default
	{
		if(typebio="Tierra"){
		draw circle(1) color:(cantidad>0)?#gray:#blue border: #darkgreen;
			//draw "Z"color:#black size:1;
			}
	}
	reflex consumir when: punto=location
	{
					list<planta> plants <- planta where (each distance_to self <= 5.0);
			ask plants
			{
				float consumption <- cant_Zinc_plant/cant_plant;
				cont_plant<-cont_plant+consumption;
			}
			cant_Zinc <- cant_Zinc - cant_Zinc_plant/cant_plant; //LD
			do die;
				}
	reflex goto when: typebio="Tierra"{
		//mypoint<-{rnd(12),rnd(12),rnd(12)};
		if (target != nil){
			do goto target: punto speed: vel_proteina;
		}
		
		if(mypoint = location){
			cont <- cont + suma;
			do die;			
		}
	}

}

//para la pantalla correr experimento y parametros
experiment name type: gui {
	
	/*Ambiente */
	parameter "Cantidad_Plantas"	var:cant_plant<-5;
	//parameter "Fertilizar" 			var: fertilizar <- true;
	
	/*Planta */
	parameter "Tipo Planta" var:tipoplant<-"Maiz";
	parameter "Tiempo de Vida" var:timelive<-0.0;
	//parameter "Tiempo Florecimiento" var:timeflor<-0.0;
	parameter "Temp max" var:tempmax<-0.0;
	parameter "Temp min" var:tempmin<-0.0;
	parameter "Luminosidad min" 	var: lightmin <- 2000;
	parameter "Luminosisda max" 	var: lightmax <- 7000;
	
	/*Necesidades Nutricionales */
	parameter "Nitrógeno(Planta)" var:cant_Nitrogeno_plant;
	parameter "Fósforo(Planta)"   var:cant_Fosforo_plant;
	parameter "Potasio(Planta)"   var:cant_Potasio_plant;
	parameter "Magnesio(Planta)"  var:cant_Magnesio_plant;
	parameter "Calcio(Planta)"    var:cant_Calcio_plant;
	parameter "Asufre(Planta)"    var:cant_Azufre_plant;
	parameter "Boro(Planta)"      var:cant_Boro_plant;
	parameter "Cobre(Planta)"     var:cant_Cobre_plant;
	parameter "Hierro(Planta)"    var:cant_Hierro_plant;
	parameter "Manganeso(Planta)" var:cant_Manganeso_plant;
	parameter "Molibdeno(Planta)" var:cant_Molibdeno_plant;
	parameter "Zinc(Planta)"      var:cant_Zinc_plant;
	
	/*Biomasa */
	parameter "Tipo BioMass"      var:typebio<-"Tierra";
	parameter "Nitrógeno"         var:cant_Nitrogeno;
	parameter "Fósforo"           var:cant_Fosforo;
	parameter "Potasio"           var:cant_Potasio;
	parameter "Magnesio"          var:cant_Magnesio;
	parameter "Calcio"            var:cant_Calcio;
	parameter "Asufre"            var:cant_Azufre;
	parameter "Boro"              var:cant_Boro;
	parameter "Cobre"             var:cant_Cobre;
	parameter "Hierro"            var:cant_Hierro;
	parameter "Manganeso"         var:cant_Manganeso;
	parameter "Molibdeno"         var:cant_Molibdeno;
	parameter "Zinc"              var:cant_Zinc;
	
	/* ================ Database ====================== */
	parameter "Servidor" 		var:server;
	parameter "Tipo" 			var:dbType;
	parameter "Base de datos" 	var:database;
	parameter "Puerto" 			var:port;
	parameter "Usuario" 		var:user;
	parameter "Contraseña" 		var:password;	

	output {
		 display map type: opengl background:rgb(204, 255, 255){ 
		
		//species ramas;
		species biomass aspect: default;
		species Nitrogeno;
		species Fosforo aspect: default;
		species Potasio;
		species Calcio aspect: default;
		species Magnesio aspect: default;
		species Azufre;
		species Boro aspect: default;
		species Cobre aspect: default;
		species Hierro aspect:default;
		species Manganeso;
		species Molibdeno aspect: default;
		species Zinc aspect: default;
		species planta aspect:default;
		species arcilla aspect: default;			
	 }
	 /* ============== Monitors ============== */
		monitor Temperatura value: temp_env 	refresh: every(5#cycle);
		monitor Flujo_Aire 	value: airFlow_env 	refresh: every(5#cycle);
		monitor Humedad 	value: humidity_env refresh: every(5#cycle);
		monitor Luminosidad value: light_env 	refresh: every(5#cycle);
	 	monitor Edad value: edad 	refresh: every(3#cycle);
	}
	
}