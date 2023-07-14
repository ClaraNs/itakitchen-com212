import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams, ToastController } from 'ionic-angular';
import { ShareService } from '../share/share';

/**
 * Generated class for the EsquecerSenhaPage page.
 *
 * See https://ionicframework.com/docs/components/#navigation for more info on
 * Ionic pages and navigation.
 */

@IonicPage()
@Component({
  selector: 'page-esquecer-senha',
  templateUrl: 'esquecer-senha.html',
})
export class EsquecerSenhaPage {

  email: any = null;
  novasenha: any = null;
  codigo: any;
  emailEnviado: any = false;
  codigoVerificado: any = false;

  constructor(public navCtrl: NavController, public navParams: NavParams, private toastCtrl: ToastController, private share: ShareService) {
  }

  continuar() {
    if (this.email != null) {
      if (this.email.includes('@') && this.email.split('@')[1] != '') {
        this.share.enviarEmailSenha(this.email).subscribe((data: any) => {
          console.log(data);
          if (data == 1) {
            let toast = this.toastCtrl.create({
              message: "E-mail enviado com sucesso!",
              duration: 2000
            });
            toast.present();
            this.emailEnviado = true;
          } else {
            let toast = this.toastCtrl.create({
              message: "Algo deu errado...",
              duration: 2000
            });
            toast.present();
          }
        });
      } else {
        let toast = this.toastCtrl.create({
          message: "O e-mail deve conter um '@' e uma parte depois do '@'.",
          duration: 2000
        });
        toast.present();
      }
    } else {
      let toast = this.toastCtrl.create({
        message: "O e-mail deve ser preenchido.",
        duration: 2000
      });
      toast.present();
    }
  }


  resetarSenha() {
    this.share.resetaSenha(this.novasenha, this.email, this.codigo).subscribe((data: any) => {
      if (data == 1) {
        let toast = this.toastCtrl.create({
          message: "Senha alterada com sucesso!",
          duration: 2000
        });
        toast.present();
        this.navCtrl.pop();
      } else {
        let toast = this.toastCtrl.create({
          message: "Token inválido.",
          duration: 2000
        });
        toast.present();
      }
    });

  }

}
