import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams } from 'ionic-angular';
import { UsuarioPage } from '../usuario/usuario';
import { InicioPage } from '../inicio/inicio';

/**
 * Generated class for the MinhasAvaliacoesPage page.
 *
 * See https://ionicframework.com/docs/components/#navigation for more info on
 * Ionic pages and navigation.
 */

@IonicPage()
@Component({
  selector: 'page-minhas-avaliacoes',
  templateUrl: 'minhas-avaliacoes.html',
})
export class MinhasAvaliacoesPage {

  usuario:any = [];

  constructor(public navCtrl: NavController, public navParams: NavParams) {
  this.usuario = this.navParams.get('usuario');
  }


  menu(){
    this.navCtrl.push(InicioPage, { usuario: this.usuario }, { animate: true });
  }
  
  acessarPerfil() {
    this.navCtrl.push(UsuarioPage, { usuario: this.usuario, clienteOuEstab: 0 },
      { animate: true });
  }

}
