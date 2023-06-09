import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams, ToastController } from 'ionic-angular';
import { ShareService } from '../share/share';
import { InicioPage } from '../inicio/inicio';
import { CadastroTipoPage } from '../cadastro-tipo/cadastro-tipo';
import { Storage } from '@ionic/storage';
import { EsquecerSenhaPage } from '../esquecer-senha/esquecer-senha';

/**
 * Generated class for the LoginPage page.
 *
 * See https://ionicframework.com/docs/components/#navigation for more info on
 * Ionic pages and navigation.
 */

@IonicPage()
@Component({
  selector: 'page-login',
  templateUrl: 'login.html',
})
export class LoginPage {

  email: any = null;
  senha: any = null;
  formValidacao: any;
  conectado: any = false;

  constructor(public navCtrl: NavController, public navParams: NavParams, private share: ShareService, private toastCtrl: ToastController,
    public storage: Storage) {
    this.storage.get('email').then((val) => {
      if (val != null) {
        this.email = val;
        this.storage.get('senha').then((val) => {
          if (val != null) {
            this.senha = val;
            this.storage.get('conectado').then((val) => {
              if (val != null) {
                this.conectado = val;
                if (this.conectado == true) {
                  this.fazerLogin();
                }
              }
            });
          }
        });
      }
    });

    

  }

  atualizaConectado(){
    this.storage.set("conectado", this.conectado);
  }

  cadastro() {
    this.navCtrl.push(CadastroTipoPage, {}, { animate: true })
  }

  esqueciSenha(){
    this.navCtrl.push(EsquecerSenhaPage, {}, { animate: true })
  }

  fazerLogin() {

    if (this.email != null && this.senha != null) {
      if (this.email.includes('@') && this.email.split('@')[1] != '') {
        this.share.verificaLogin(this.email, this.senha).subscribe((data: any) => {
          console.log(data);
          if (data != 0) {
            if (data[0].cpf != undefined) {
              let cliente = {
                id: data[0].id,
                email: data[0].email,
                nome: data[0].nome,
                cpf: data[0].cpf,
                datanas: data[0].dataNascimento,
                foto: data[0].foto,
                tipo: data[0].tipo
              };

              this.storage.set("email", this.email);
              this.storage.set("senha", this.senha);
              this.storage.set("conectado", this.conectado);

              this.navCtrl.push(InicioPage, { usuario: cliente }, { animate: true });
            } else {
              let estab = {
                id: data[0].id,
                email: data[0].email,
                nome: data[0].nome,
                cnpj: data[0].cnpj,
                descricao: data[0].descricao,
                contato: data[0].contato,
                foto: data[0].foto,
                idendereco: data[0].idEndereco,
                idhorariofunc: data[0].idHorario,
                idcategoria: data[0].idCategoria,
              };
              this.storage.set("email", this.email);
              this.storage.set("senha", this.senha);
              this.navCtrl.push(InicioPage, { usuario: estab }, { animate: true });
            }

          } else {
            let toast = this.toastCtrl.create({
              message: "Usuário não encontrado. Verifique os dados inseridos.",
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
        message: "Preencha todos os campos.",
        duration: 2000
      });
      toast.present();
    }
  }

}
