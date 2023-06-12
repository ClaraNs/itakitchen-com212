import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams, ToastController } from 'ionic-angular';
import { CadastroClientePage } from '../cadastro-cliente/cadastro-cliente';
import { CadastroEstabelecimentoPrimeiroPage } from '../cadastro-estabelecimento-primeiro/cadastro-estabelecimento-primeiro';

/**
 * Generated class for the CadastroGeralPage page.
 *
 * See https://ionicframework.com/docs/components/#navigation for more info on
 * Ionic pages and navigation.
 */

@IonicPage()
@Component({
  selector: 'page-cadastro-geral',
  templateUrl: 'cadastro-geral.html',
})
export class CadastroGeralPage {

  tipo: any = null;
  email: any = null;
  senha: any = null;

  constructor(public navCtrl: NavController, public navParams: NavParams, private toastCtrl: ToastController) {
    this.tipo = this.navParams.get('tipo');
  }

  continuar() {
    if (this.email != null && this.senha != null) {
      if (this.email.includes('@') && this.email.split('@')[1] != '') {
        if (this.tipo == 'cliente') {
          this.navCtrl.push(CadastroClientePage, { email: this.email, senha: this.senha }, { animate: true });
        }else{
          this.navCtrl.push(CadastroEstabelecimentoPrimeiroPage, { email: this.email, senha: this.senha }, { animate: true });
        }
      } else {
        let toast = this.toastCtrl.create({
          message: "O e-mail deve conter um '@' e uma parte depois do '@'.",
          duration: 2000
        });
        toast.present();
      }
    } else {
      let toast = this.toastCtrl.create({
        message: "Preencha todos os campos.",
        duration: 2000
      });
      toast.present();
    }

  }

}
