import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams } from 'ionic-angular';

/**
 * Generated class for the CadastroEstabelecimentoPrimeiroPage page.
 *
 * See https://ionicframework.com/docs/components/#navigation for more info on
 * Ionic pages and navigation.
 */

@IonicPage()
@Component({
  selector: 'page-cadastro-estabelecimento-primeiro',
  templateUrl: 'cadastro-estabelecimento-primeiro.html',
})
export class CadastroEstabelecimentoPrimeiroPage {

  constructor(public navCtrl: NavController, public navParams: NavParams) {
  }

  ionViewDidLoad() {
    console.log('ionViewDidLoad CadastroEstabelecimentoPrimeiroPage');
  }

}
