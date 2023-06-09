import { Component } from '@angular/core';
import { NavController } from 'ionic-angular';
import { LoginPage } from '../login/login';
import { CadastroTipoPage } from '../cadastro-tipo/cadastro-tipo';

@Component({
  selector: 'page-home',
  templateUrl: 'home.html'
})
export class HomePage {

  constructor(public navCtrl: NavController) {

  }

  login(){
    this.navCtrl.push(LoginPage, {}, {animate: true})
  }

  cadastro(){
    this.navCtrl.push(CadastroTipoPage, {}, {animate: true})
  }

}
