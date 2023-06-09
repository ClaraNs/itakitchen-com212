import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams, ToastController } from 'ionic-angular';
import { ShareService } from '../share/share';
import { InicioPage } from '../inicio/inicio';
import { CadastroTipoPage } from '../cadastro-tipo/cadastro-tipo';
import { Storage } from '@ionic/storage';

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

  email:any = null;
  senha:any = null;
  formValidacao:any;

  constructor(public navCtrl: NavController, public navParams: NavParams, private share:ShareService, private toastCtrl: ToastController,
    public storage:Storage) {
    this.storage.get('email').then((val) => {
      if (val != null) {
        this.email = val;
      }
    });
    this.storage.get('senha').then((val) => {
      if (val != null) {
        this.senha = val;
      }
    });
  }

  cadastro(){
    this.navCtrl.push(CadastroTipoPage, {}, {animate: true})
  }

  fazerLogin(){

    if(this.email != null && this.senha != null){
      if(this.email.includes('@') && this.email.split('@')[1] != ''){
      this.share.verificaLogin(this.email, this.senha).subscribe((data:any)=>{
        console.log(data);
        if(data.length != 0){
          let cliente = {
            id: data[0].id, 
            email:  data[0].email, 
            nome: data[0].nome, 
            cpf: data[0].cpf, 
            datanas: data[0].dataNascimento, 
            foto: data[0].foto, 
            tipo: data[0].tipo
          };
          this.storage.set("email", this.email);
          this.storage.set("senha", this.senha);
          this.navCtrl.push(InicioPage, {cliente: cliente}, {animate: true});
        
        }else{
          let toast = this.toastCtrl.create({
            message: "Usuário não encontrado. Verifique os dados inseridos.",
            duration: 2000
          });
          toast.present();
        }
      });
    }else{
      let toast = this.toastCtrl.create({
        message: "O e-mail deve conter um '@' e uma parte depois do '@'.",
        duration: 2000
      });
      toast.present();
    }
    }else{
      let toast = this.toastCtrl.create({
        message: "Preencha todos os campos.",
        duration: 2000
      });
      toast.present();
    }
  }

}
