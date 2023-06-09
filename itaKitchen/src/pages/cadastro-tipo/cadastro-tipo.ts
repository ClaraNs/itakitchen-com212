import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams } from 'ionic-angular';
import { CadastroGeralPage } from '../cadastro-geral/cadastro-geral';

/**
 * Generated class for the CadastroTipoPage page.
 *
 * See https://ionicframework.com/docs/components/#navigation for more info on
 * Ionic pages and navigation.
 */

@IonicPage()
@Component({
  selector: 'page-cadastro-tipo',
  templateUrl: 'cadastro-tipo.html',
})
export class CadastroTipoPage {

  constructor(public navCtrl: NavController, public navParams: NavParams) {
  }

  cadastroGeral(tipo){
    this.navCtrl.push(CadastroGeralPage, {tipo: tipo}, {animate: true})
  }

}
