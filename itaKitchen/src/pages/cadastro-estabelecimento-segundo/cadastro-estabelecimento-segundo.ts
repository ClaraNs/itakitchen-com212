import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams } from 'ionic-angular';

/**
 * Generated class for the CadastroEstabelecimentoSegundoPage page.
 *
 * See https://ionicframework.com/docs/components/#navigation for more info on
 * Ionic pages and navigation.
 */

@IonicPage()
@Component({
  selector: 'page-cadastro-estabelecimento-segundo',
  templateUrl: 'cadastro-estabelecimento-segundo.html',
})
export class CadastroEstabelecimentoSegundoPage {

  constructor(public navCtrl: NavController, public navParams: NavParams) {
  }

  ionViewDidLoad() {
    console.log('ionViewDidLoad CadastroEstabelecimentoSegundoPage');
  }

}
