#! /usr/bin/bash

echo Probando script Generacion de archivos genericos para ABM y listados!
cd src/app
#VARIABLES
#Uppercase by conevention
#Letter, number, underscores
NAME="Ali"
# echo "My name is $NAME"
# echo "My name is ${NAME}"

#Input 
read -p "Enter section name: " SECTION
read -p "Enter singular name: " SINGULAR

declare -a PROPERTIES

read -p "Quiere agrgar propiedades? Y/N " ANSWER
case "$ANSWER" in
    [yY] | [yY][eE][sS])
        read -p "Agregar propiedades ( -f para terminar): " PROPERTY
        while [[ ${PROPERTY} !=  '-f' ]]; do
            if [[ -z ${PROPERTY} ]];then
                break
            fi
            PROPERTIES+=(${PROPERTY})
            read -p "Agregar propiedades ( -f para terminar): " PROPERTY
        done
        for value in "${PROPERTIES[@]}"
        do
            echo $value
        done
        ;;
    [nN] |[nN][oO])
    echo "Esta bien, su componente esta siendo generado"
    ;;
    *)
        ;;
esac


touch _routes.ts
mkdir ./services/http/${SECTION}
touch ./services/http/${SECTION}/${SECTION}.resolver.ts
#!/bin/bash
cat >>_routes.ts <<EOF
  
  {
    path:'${SECTION}',
    loadChildren: ()=>
    import("./views/${SECTION}/${SECTION}.module").then((m)=>m.${SECTION^}Module)
  },
EOF
cat >>_nav.ts <<EOF
  
  {
    divider: true,
  },
  {
    title:true,
    name:'${SECTION^}',
    class:"strong-font"
  },
  {
    name:'Listado ${SECTION^}',
    url:'${SECTION} / listar',
    icon:'fa fa-institution scaling strong-icon',
    class:"strong-font"
  },
  {
    name:'Crear ${SINGULAR^}',
    url:'${SECTION} / crear',
    icon:'fa fa-paint-brush scaling strong-icon',
    class:"strong-font"
  },
EOF
cat > ./services/http/${SECTION}/${SECTION}.resolver.ts <<EOF
import { Injectable } from '@angular/core';
import {Resolve,
  RouterStateSnapshot,
  ActivatedRouteSnapshot
} from '@angular/router';
import { Observable, of } from 'rxjs';
import { RootService } from '../root.service';

@Injectable({
  providedIn: 'root'
})
export class All${SECTION^}Resolver implements Resolve<unknown> {
  constructor(private rootService:RootService){}
  resolve(route: ActivatedRouteSnapshot, state: RouterStateSnapshot): Observable<unknown> {
    return this.rootService.getAll('${SECTION}')
  }
}
@Injectable({
  providedIn: 'root'
})
export class ${SINGULAR^}Resolver implements Resolve<unknown> {
  constructor(private rootService:RootService){}
  resolve(route: ActivatedRouteSnapshot, state: RouterStateSnapshot): Observable<unknown> {
    const{id} = route.params
    return this.rootService.getOne('${SECTION}',id)
  }
}
@Injectable({
  providedIn: 'root'
})
export class ${SECTION^}Resolver implements Resolve<unknown> {
  constructor(private rootService:RootService){}
  resolve(route: ActivatedRouteSnapshot, state: RouterStateSnapshot): Observable<unknown> {
    const {take,page,search} = route.queryParams
    return this.rootService.index('${SECTION}',page,take,search)
  }
}
EOF

mkdir ./views/${SECTION}
touch ./views/${SECTION}/${SECTION}-routing.module.ts
touch ./views/${SECTION}/${SECTION}.module.ts
cat>./views/${SECTION}/${SECTION}-routing.module.ts<<EOF
import { NgModule } from "@angular/core";
import { Routes, RouterModule } from "@angular/router";
import { ${SINGULAR^}Resolver, ${SECTION^}Resolver } from "../../services/http/${SECTION}/${SECTION}.resolver";
import { FormComponent } from "./pages/form/form.component";
import { ListComponent } from './pages/list/list.component';
import { campsTemplate, campsValidation } from "./templates/form.template";
import { template } from "./templates/list.template";

const routes: Routes = [
  {
    path: "",
    data: {
      title: "${SECTION^}",
    },
    children: [
      {
        path: "crear",
        component: FormComponent,
        data: 
        { 
          title: "Nuevo ${SINGULAR^}",
          campsValidation: campsValidation,
          campsTemplate : campsTemplate
         },
      },
      {
        path: "listar",
        component: ListComponent,
        resolve:{${SECTION}: ${SECTION^}Resolver},
        data:
        {
          title: "Listado ${SECTION^}" ,
          template: template
        },
      },
      {
        path: ":id/editar",
        component: FormComponent,
        resolve:{${SINGULAR}: ${SINGULAR^}Resolver},
        data:
        { 
          title: "Editar ${SINGULAR^}",
          campsValidation: campsValidation,
          campsTemplate : campsTemplate 
        },
      },
    ],
  },
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class ${SECTION^}RoutingModule {}
export const routingComponents = [FormComponent,ListComponent];
EOF
cat>./views/${SECTION}/${SECTION}.module.ts<<EOF
import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';
import { ReactiveFormsModule, FormsModule } from '@angular/forms';
import { PaginationModule } from 'ngx-bootstrap/pagination';
import { SharedModule } from '../../shared/shared.module';
import { ${SECTION^}RoutingModule, routingComponents } from './${SECTION}-routing.module';
import { RootModule } from '../../root/root.module';

@NgModule({
  imports: [
    ${SECTION^}RoutingModule,
    ReactiveFormsModule,
    CommonModule,
    PaginationModule,
    FormsModule,
    SharedModule,
    RootModule
  ],
  declarations: routingComponents
})
export class ${SECTION^}Module { }
EOF
cd ./views/${SECTION}
mkdir pages
mkdir templates
cd pages
mkdir form
mkdir list

touch ./form/form.component.html
touch ./form/form.component.ts
touch ./list/list.component.html
touch ./list/list.component.ts
cat>./form/form.component.html<<EOF
<app-root-form 
    #form
    [template]="campsTemplate"
    [camps]="campsForm"
    [validation]="campsValidation"
    [title]="title"
    [forEdit]="${SINGULAR}ForEdit"
    [selectOptions]="optionsPassed"
    section="${SECTION}"
>
</app-root-form>
EOF
cat>./form/form.component.ts<<EOF
import { Component, OnInit, ViewChild } from "@angular/core";
import { Validators } from "@angular/forms";
import { ActivatedRoute } from "@angular/router";
import { RootFormComponent } from '../../../../root/root-form/root-form.component';
import { campsDirector, campsRepresentante } from "../../templates/form.template";  //CAMPOS AGREGADOS A TRAVES DE ALGUN CAMBIO 


@Component({
  templateUrl: "form.component.html",
  styleUrls: ["../../../../app.component.css"]
})
export class FormComponent implements OnInit {
  constructor(private activatedRoute: ActivatedRoute) {}

  @ViewChild(RootFormComponent)form: RootFormComponent 

  title = ''

  valueNuevo = {id:-1,nombre_completo:'Nuevo'} //AGREGAR OPCION DE CREAR NUEVO 
  activoInactivoOptions :any[]=[ {value:0,descripcion:'Inactivo'},{value:1,descripcion:'Activo'}]
  
  optionsPassed :any[] =[]
  campsTemplate  =[]
  campsValidation ={}

  campsForm = []
  ${SINGULAR}ForEdit = false

  ngOnInit(){
    this.activatedRoute.data.subscribe(data=>{
      this.title = data.title
      this.campsValidation = data.campsValidation
      this.campsTemplate= data.campsTemplate
      Object.keys(this.campsValidation).forEach(camp=>this.campsForm.push(camp))
      this.optionsPassed.push(this.activoInactivoOptions) // RECORDAR PUSHEAR DE ACUERDO AL INDEX QUE TENGA EN EL TEMPLATE
      if(data.${SINGULAR}){
        this.${SINGULAR}ForEdit = data.${SINGULAR}
      }
    })
  }

  ngAfterViewInit(): void {
    //ACA HACER USO DEL FORM
    //this.form.form.controls['fila'].valueChanges.subscribe(values=>{
    //  if(this.form.form.controls['fila'].valid) this.form.form.controls['username'].enable()
    //  else this.form.form.controls['username'].disable()
    //})
    //this.form.form.valueChanges.subscribe(form=>{
    //  console.log(this.form.form.valid)
    //})
  }
}
EOF
event='$event'
cat>./list/list.component.html<<EOF
<div #topScrollAnchor></div>
<div class="row wrapp-all animated fadeIn">
  <div class="col-sm-12 pb-2">
    <div class="row" style="height: 7vh">
      <div class="col-xl-6">
        <label class="form-title"
          >{{ title }}
          {{
              ? "(" + itemsPerPage + " de " + totalItems + ")"
              : ""
          }}</label
        >
      </div>
      <div class="col-xl-6 pb-2">
        <div class="row">
          <div class="col-7">
            <app-shared-searcher
              (valueSearch)="search(${event})"
            >
            </app-shared-searcher>
          </div>
          <div class="col-5">
            <div class="row">
              <div class="col-8">
                <button
                  class="btn btn-block btn-primary pl-1 pr-1"
                  routerLink="/${SECTION}/crear"
                  *ngIf="showListObjects"
                >
                  <i class="fa fa-plus"></i><strong> CREAR</strong>
                </button>
              </div>
              <div class="col-4">
                <button class="btn btn-block btn-secondary">
                  <i class="icon-menu"></i>
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="col-12">
        <div class="row">
          <div class="col-sm-12" style="padding-bottom: 2vh" >
          <app-root-list
            [template]="templ"
            [listado]="listForTemplate"
            [queryPlus]="queryPlusSet"
            section="${SECTION}"
          >
        </app-root-list>
      </div>
      </div>
      </div>
      
      <div class="col-12">
        <div class="row justify-content-between">
          <div class="col-xs-1 ml-4">
            <app-shared-take-paginator
              [i_perPage]="itemsPerPage"
              (c_TotalItems)="changeTotalItems(${event})"
            >
            </app-shared-take-paginator>
          </div>
          <div class="row ml-3  mr-2">
            <div class="col-12">
              <div class="d-inline-block mr-3">
                Pagina {{ currentPage }} de {{ totalPages }}
              </div>
              <div class="d-inline-block">
                <pagination
                  class="pagination-md"
                  [maxSize]="5"
                  [(ngModel)]="currentPage"
                  [totalItems]="totalItems"
                  previousText="&lsaquo;"
                  nextText="&rsaquo;"
                  firstText="&laquo;"
                  lastText="&raquo;"
                  [boundaryLinks]="true"
                  (pageChanged)="pageChange(${event})"
                  [itemsPerPage]="itemsPerPage"
                >
                </pagination>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div> 
  </div>
</div>
EOF
cat>./list/list.component.ts<<EOF
import { Component, ElementRef, OnInit, ViewChild } from "@angular/core";
import { ActivatedRoute, Router } from "@angular/router";
import { ${SINGULAR^} } from "../../../../shared/models/${SINGULAR}.model";
import { RootService } from '../../../../services/http/root.service';
import { setData, setValueQueryPlus } from "../../templates/list.template";


@Component({
  selector: "app-list",
  templateUrl: "./list.component.html",
  styleUrls: ["../../../../app.component.css"],
})
export class ListComponent implements OnInit {
@ViewChild('topScrollAnchor')topScroll:ElementRef
  currentPage = 1;
  totalItems = 0;
  itemsPerPage = 30;
  totalPages = 0;
  searchValue: string = "";
  queryParams = { queryParams: { page: 1, take: 30, search: null } };

  title =''

  constructor(
    private activatedRoute: ActivatedRoute,
    private rootService: RootService,
    private router: Router, 
  ) {}


  ngOnInit() {    
    this.activatedRoute.data.subscribe((data) => {
      this.${SECTION} = data.${SECTION}.data
      this.title = data.title
      this.templ = data.template
      if (data.${SECTION}.pagination) {
        this.totalPages = data.${SECTION}.pagination.totalPages;
        this.currentPage = data.${SECTION}.pagination.actualPage;
        this.totalItems = data.${SECTION}.pagination.totalResults;
        this.itemsPerPage = data.${SECTION}.pagination.resultPerPage;
        this.queryParams.queryParams.page =
          data.${SECTION}.pagination.actualPage;
        this.queryParams.queryParams.take =
          data.${SECTION}.pagination.resultPerPage;
      }
    });
    this.activatedRoute.queryParams.subscribe((query) => {
      this.rootService
        .index('${SECTION}',query.page, query.take, query.search)
        .subscribe((res: any) => {
            this.listForTemplate = []
            this.${SECTION} = res.data
            this.${SECTION}.forEach(${SINGULAR}=>{
                const ${SINGULAR}Data = this.setData(${SINGULAR})
                const ${SINGULAR}Query = this.setValueQueryPlus(${SINGULAR})
                this.queryPlusSet.push(${SINGULAR}Query)
              this.listForTemplate.push(${SINGULAR}Data)
            })
            this.itemsPerPage =res.pagination.resultPerPage;
            this.totalItems = res.pagination.totalResults;
            this.totalPages = res.pagination.totalPages;
          });
        });
      }
  changeTotalItems(total: number) {
    this.topScroll.nativeElement.scrollIntoView();
    this.queryParams.queryParams.take = total;
    this.router.navigate([`/${this.section}/listar`], this.queryParams);
  }
  
  pageChange(pageChange) {
    this.topScroll.nativeElement.scrollIntoView();
    this.queryParams.queryParams.page = pageChange.page;
    this.router.navigate([`/${this.section}/listar`], this.queryParams);
  }

  search(busqueda: string) {
    this.searchValue = busqueda;
    this.queryParams.queryParams.search = busqueda;
    this.queryParams.queryParams.page = 1;
    return this.router.navigate([`/${this.section}/listar`], this.queryParams);
  }

  templ = {}
  ${SECTION}: ${SINGULAR^}[] = []
  listForTemplate : any[] =[]
  queryPlusSet=[]

  setData =setData
  setValueQueryPlus = setValueQueryPlus
}
EOF
cd ..
touch ./templates/list.template.ts
touch ./templates/form.template.ts
cat>./templates/list.template.ts<<EOF
import { formatDate } from "../../../shared/functions/formatDate";
import { ${SINGULAR^} } from "../../../shared/models/${SINGULAR}.model";
import { fontName, fontNumber, fontPrimary } from "../../../shared/models/template.form.model";

export const template ={
    headIcon: 'fa fa-building mr-4 text-primary scaling',
    relations:[
        {
          //Modificar acorde a las relaciones que tenga su componente
            title : 'Director Médico',
            section:'directoresMedicos',
            unique:true,
            // plusText:'AGREGAR Relation',
            tableHeaders: [
              'Nombre Completo' ,'DNI','Teléfono Fijo','Domicilio','Fecha creacion','Fecha actualizacion'
            ],
            properties:[
              {access:'nombre_completo',font:fontName},
              {access:'dni',font:fontPrimary},
              {access:'telefono_fijo',font:fontNumber,},
              {access:'domicilio_completo',font:fontName},
              {access:'created_at',font:fontNumber+' text-right',type:'date'},
              {access:'updated_at',font:fontNumber+' text-right',type:'date'},
            ]
        },
        {
            title : 'Representante Legal',
            section:'representantesLegales',
            unique:true,
            // plusText:'AGREGAR Relation',
            tableHeaders: [
              'Nombre Completo' ,'DNI','Telefono Fijo','Domicilio','Fecha creacion','Fecha actualizacion'
            ],
            properties:[
              {access:'nombre_completo',font:fontName},
              {access:'dni',font:fontPrimary},
              {access:'telefono_fijo',font:fontNumber,},
              {access:'domicilio_completo',font:fontName},
              {access:'created_at',font:fontNumber+' text-right',type:'date'},
              {access:'updated_at',font:fontNumber+' text-right',type:'date'},
            ]
        },
    ]
}

export function setData(obj:${SINGULAR^}){
    return {
      //MODIFICAR ACORDE A LAS PROPIEDADES DE SU OBJETO
      //header: `${obj.id_centro} - ${obj.domicilio_completo}`,
      //properties: [
      //{
      //    icon:'fa fa-id-card-o',
      //    font:fontPrimary,
      //    label:'ID',
      //    data: obj.id_centro
      //},
      //{
      //    icon:'fa fa-addrescard-o',
      //    font: fontName,
      //    label:'Domicilio',
      //    data: obj.domicilio_completo
      //},
      //{
      //    icon: obj.estado?'fa fa-check text-success':'fa fa-times text-danger',
      //    font: obj.estado?'mb-0  font-weight-bold text-success':' mb-0 font-weight-bold text-danger',
      //    label:'Estado',
      //    data: obj.estado?'Activo':'Inactivo'
      //},
      //{
      //    icon:'fa fa-calendar',
      //    font:fontNumber,
      //    label:'Fecha creacion',
      //    data: formatDate(obj.created_at)
      //},
      //{
      //    icon:'fa fa-calendar',
      //    font:fontNumber,
      //    label:'Fecha actualización',
      //    data: formatDate(obj.updated_at)
      //},

  ],
  id: obj.id,
  //SI LAS RELACIONES SON DE 1 (POR EJ, NO VIENE UN ARRAY DE DIRECTORES; SOLO 1), PASAR ID PARA LA BUSQUEDA DE SUS PROPIEDADES
  //directoresMedicos: obj.director_medico_id,
  //representantesLegales: obj.representante_legal_id,
}
}
export function setValueQueryPlus(obj){
  return {centroAtencion_id : obj.id}
}
EOF
cat>./templates/form.template.ts<<EOF
import { Validators } from "@angular/forms";

export const campsValidation = {  
  //TODOS LOS CAMPOS QUE TENDRA EL FORMULARIO ACA PUEDE MODIFICAR EL VALOR POR DEFECTO Y EL TIPO DE VALIDACION
    nro_isib:[{value:null,disabled:false},[]],
    condicion_isib_id:[{value:null,disabled:false},[]],
    domicilio_completo:[{value:null,disabled:false},[]],
    ciudad:[{value:null,disabled:false},[]],
    provincia:[{value:null,disabled:false},[]],
    codigo_postal:[{value:null,disabled:false},[]],
    alic_ret_gcias:[{value:null,disabled:false},[]],
    alic_ret_isib:[{value:null,disabled:false},[]],
    alic_gtos_cadra:[{value:null,disabled:false},[]],
    alic_gtos_asoc:[{value:null,disabled:false},[]],
    estado:[{value:null,disabled:false},[]],
    tipo_centro_id:[{value:null,disabled:false},[]],
    asociacion_regional_id:[{value:null,disabled:false},[]],
    director_medico_id:[{value:null,disabled:false},[]],
    representante_legal_id:[{value:null,disabled:false},[]],
    
    id_centro:[{value:null,disabled:false},[Validators.required,]],
    email:[{value:null,disabled:false},[Validators.required,Validators.email]],
    username:[{value:null,disabled:false},[Validators.required]],
    password:[{value:null,disabled:false},[Validators.required]],
    owner_id:[{value:-1,disabled:false},[Validators.required]],
  
    dni_director:[{value:null,disabled:false},[]],
    nombre_completo_director:[{value:null,disabled:false},[]],
    nro_registro_incucai:[{value:null,disabled:false},[]],
    matricula_director:[{value:null,disabled:false},[]],
    domicilio_completo_director:[{value:null,disabled:false},[]],
    telefono_fijo_director:[{value:null,disabled:false},[]],
    telefono_celular_director:[{value:null,disabled:false},[]],
    email_director:[{value:null,disabled:false},[Validators.email]],
  
    dni_representante:[{value:null,disabled:false},[]],
    nombre_completo_representante:[{value:null,disabled:false},[]],
    cargo_representante:[{value:null,disabled:false},[]],
    domicilio_completo_representante:[{value:null,disabled:false},[]],
    telefono_fijo_representante:[{value:null,disabled:false},[]],
    telefono_celular_representante:[{value:null,disabled:false},[]],
    email_representante:[{value:null,disabled:false},[Validators.email]],
  }

//CAMPOS DEL HTML TEMPLATE, MODIFICAR CON LOS QUE USTED NECESITE UTILIZAR 
//type PUEDE SER 'input','select' o 'date' POR EL MOMENTO
//EN SELECT NECESITA PASAR index: 0 CON INDEX EN QUE PUSHEA EL ARRAY DE OPCIONES EN EL COMPONENTE
                                                    //optionsValueAccess:'propiedad de acceso al valor de la opcion'                                                   
                                                    //optionsDescriptionAccess:'propiedad de acceso a la descripcion de la opcion'                                               

  export const campsTemplate =[
    [
        {name:'username',class:'form-group col-sm-6',type:'input',label:'Usuario',required:true,typeinput:'text'},
        {name:'password',class:'form-group col-sm-6',type:'input',label:'Contraseña',required:true,typeinput:'password'},
    ],
    [
        {name:'id_centro',class:'form-group col-sm-6',type:'input',label:'ID Centro',required:true,typeinput:'text'},
        {name:'email',class:'form-group col-sm-6',type:'input',label:'Email',required:true,typeinput:'text'},
    ],
    [
      {name:'nro_isib',class:'form-group col-sm-4',type:'input',label:'Número ISIB',required:false,typeinput:'number'},
      {name:'condicion_isib_id',class:'form-group col-sm-4',type:'select',index:0,optionsValueAccess:'id',optionsDescriptionAccess:'titulo',label:'Condición ISIB',required:false,typeinput:'text'},
    ],
    [
      {name:'domicilio_completo',class:'form-group col-sm-6',type:'input',label:'Dirección',required:false,typeinput:'text'},
      {name:'ciudad',class:'form-group col-sm-6',type:'input',label:'Ciudad',required:false,typeinput:'text'},
    ],
    [
        {name:'provincia',class:'form-group col-sm-6',type:'input',label:'Provincia',required:false,typeinput:'text'},
        {name:'codigo_postal',class:'form-group col-sm-6',type:'input',label:'Código Postal',required:false,typeinput:'text'},
    ],
    [
        {name:'alic_ret_gcias',class:'form-group col-sm-3',type:'input',label:'Alic Ret Gcias',required:false,typeinput:'text'},
        {name:'alic_ret_isib',class:'form-group col-sm-3',type:'input',label:'Alic Ret ISIB',required:false,typeinput:'text'},
        {name:'alic_gtos_asoc',class:'form-group col-sm-3',type:'input',label:'Alic Gtos Asoc',required:false,typeinput:'text'},
        {name:'alic_gtos_cadra',class:'form-group col-sm-3',type:'input',label:'Alic Gtos CADRA',required:false,typeinput:'text'},
    ],
    [
        {name:'estado',class:'form-group col-sm-4',type:'select',index:5,optionsValueAccess:'value',optionsDescriptionAccess:'descripcion',label:'Estado',required:false,typeinput:'text'},
        {name:'tipo_centro_id',class:'form-group col-sm-4',type:'select',index:2,optionsValueAccess:'id',optionsDescriptionAccess:'titulo',label:'Tipo Centro',required:false,typeinput:'text'},
        {name:'asociacion_regional_id',class:'form-group col-sm-4',type:'select',index:1,optionsValueAccess:'id',optionsDescriptionAccess:'titulo',label:'Asociación',required:false,typeinput:'text'},
    ],
    [
        {name:'director_medico_id',class:'form-group col-sm-6',type:'select',index:3,optionsValueAccess:'id',optionsDescriptionAccess:'nombre_completo',label:'Director Médico',typeinput:'text'},
      ],
      [
      {name:'representante_legal_id',class:'form-group col-sm-6',type:'select',index:4,optionsValueAccess:'id',optionsDescriptionAccess:'nombre_completo',label:'Representante Legal',typeinput:'text'},
    ]
  ]

//CAMPOS ADICIONALES QUE SE UTILICEN 

  export const  campsDirector =[
    {name:'director_medico_id',class:'form-group col-sm-12',type:'select',index:3,optionsValueAccess:'id',optionsDescriptionAccess:'nombre_completo',label:'Director Médico',required:true,typeinput:'text'},
    {name:'nombre_completo_director',class:'form-group col-sm-6',type:'input',label:'Nombre Completo  Director',required:true,typeinput:'text'},
    {name:'dni_director',class:'form-group col-sm-6',type:'input',label:'DNI  Director',required:true,typeinput:'text'},
    {name:'nro_registro_incucai',class:'form-group col-sm-6',type:'input',label:'Nro Registro INCUCAI',required:true,typeinput:'text'},
    {name:'matricula_director',class:'form-group col-sm-6',type:'input',label:'Matrícula  Director',required:true,typeinput:'text'},
    {name:'domicilio_completo_director',class:'form-group col-sm-6',type:'input',label:'Domicilio Completo Director',required:true,typeinput:'text'},
    {name:'telefono_fijo_director',class:'form-group col-sm-6',type:'input',label:'Teléfono Fijo',required:true,typeinput:'text'},
    {name:'telefono_celular_director',class:'form-group col-sm-6',type:'input',label:'Teléfono Célular',required:true,typeinput:'text'},
    {name:'email_director',class:'form-group col-sm-6',type:'input',label:'Email Director',required:true,typeinput:'text'},
  ]

  export const campsRepresentante = [
    {name:'representante_legal_id',class:'form-group col-sm-12',type:'select',index:4,optionsValueAccess:'id',optionsDescriptionAccess:'nombre_completo',label:'Representante Legal',required:true,typeinput:'text'},
    {name:'nombre_completo_representante',class:'form-group col-sm-6',type:'input',label:'Nombre Completo  Representante',required:true,typeinput:'text'},
    {name:'dni_representante',class:'form-group col-sm-6',type:'input',label:'DNI  Representante',required:true,typeinput:'text'},
    {name:'cargo_representante',class:'form-group col-sm-6',type:'input',label:'Cargo',required:true,typeinput:'text'},
    {name:'domicilio_completo_representante',class:'form-group col-sm-6',type:'input',label:'Domicilio Completo  Representante',required:true,typeinput:'text'},
    {name:'telefono_fijo_representante',class:'form-group col-sm-6',type:'input',label:'Teléfono Fijo',required:true,typeinput:'text'},
    {name:'telefono_celular_representante',class:'form-group col-sm-6',type:'input',label:'Teléfono Célular',required:true,typeinput:'text'},
    {name:'email_representante',class:'form-group col-sm-6',type:'input',label:'Email Representante',required:true,typeinput:'text'},
    
]
EOF
cd ..
cd ..
touch ./shared/models/${SINGULAR}.model.ts
cat>./shared/models/${SINGULAR}.model.ts<<EOF
export interface ${SINGULAR^}{
    //SUS PROPIEDADES "${PROPERTIES[@]}"
    //EDITE EL SIGUIENTE EJEMPLO CON SUS PROPIEDADES
    id:number,
    propiedad1:string
    propiedad2:number
    propiedad3:Date
}
EOF

echo 'Recordar limpiar las comillas en list.component,mover  el lazy-loading de _routes dentro del array y limpiar los espacios en las rutas del _nav !'
#Simple if statement 

# if [ "$NAME" == "Brand" ]
# then
#     echo "Your name is Brand"
# fi 
#fi para cerrar el if
# if [ "$NAME" == "Brand" ]
# then
#     echo "Your name is Brand"
# else
#     echo "Your name is NOT Brand"
# fi 
#fi para cerrar el if
#RECORDAR!!! uso de los espacios entre las variables en las condiciones Y LOS CORCHETES[], cuando se esta designando la variable no lleva espacio !!
