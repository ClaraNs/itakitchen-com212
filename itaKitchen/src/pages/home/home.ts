import { Component } from '@angular/core';
import { NavController } from 'ionic-angular';
import { LoginPage } from '../login/login';
import { CadastroTipoPage } from '../cadastro-tipo/cadastro-tipo';
import { Storage } from '@ionic/storage';

@Component({
  selector: 'page-home',
  templateUrl: 'home.html'
})
export class HomePage {

  constructor(public navCtrl: NavController, public storage:Storage) {
    this.storage.get('email').then((val) => {
      if (val != null) {
        this.login();
      }
    });
  }

  login(){
    this.navCtrl.push(LoginPage, {}, {animate: true})
  }

  cadastro(){
    this.navCtrl.push(CadastroTipoPage, {}, {animate: true})
  }

}
