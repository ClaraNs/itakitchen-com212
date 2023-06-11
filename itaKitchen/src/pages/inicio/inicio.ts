import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams } from 'ionic-angular';
import { UsuarioPage } from '../usuario/usuario';
import { MinhasAvaliacoesPage } from '../minhas-avaliacoes/minhas-avaliacoes';

/**
 * Generated class for the InicioPage page.
 *
 * See https://ionicframework.com/docs/components/#navigation for more info on
 * Ionic pages and navigation.
 */

@IonicPage()
@Component({
  selector: 'page-inicio',
  templateUrl: 'inicio.html',
})
export class InicioPage {

  clienteOuEstab: any = 0; //0 Cliente - 1 Estabelecimento 
  usuario:any = null;
  estabelecimentos:any = [];

  constructor(public navCtrl: NavController, public navParams: NavParams) {
    if(this.navParams.get("cliente") != undefined){
      this.clienteOuEstab = 0;
      this.usuario = this.navParams.get("cliente");
      //this.carregarEstabelecimentos();
    }
  }

  acessarPerfil(){
    this.navCtrl.push(UsuarioPage, {usuario: this.usuario, clienteOuEstab: this.clienteOuEstab}, 
      {animate: true});
  }

  minhasAvaliacoes(){
    this.navCtrl.push(MinhasAvaliacoesPage, {usuario: this.usuario, clienteOuEstab: this.clienteOuEstab}, 
      {animate: true});
  }

  sair(){
    this.navCtrl.pop();
  }

  carregarEstabelecimentos() {
    throw new Error('Method not implemented.');
  }



}
