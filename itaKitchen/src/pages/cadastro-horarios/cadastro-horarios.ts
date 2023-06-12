import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams, ToastController } from 'ionic-angular';
import { ShareService } from '../share/share';
import { LoginPage } from '../login/login';

/**
 * Generated class for the CadastroHorariosPage page.
 *
 * See https://ionicframework.com/docs/components/#navigation for more info on
 * Ionic pages and navigation.
 */

@IonicPage()
@Component({
  selector: 'page-cadastro-horarios',
  templateUrl: 'cadastro-horarios.html',
})
export class CadastroHorariosPage {

  hdomingoinicio:any = null;
  hdomingofim:any = null;
  hsegundainicio:any = null;
  hsegundafim:any = null;
  htercainicio:any = null;
  htercafim:any = null;
  hquartainicio:any = null;
  hquartafim:any = null;
  hquintainicio:any = null;
  hquintafim:any = null;
  hsextainicio:any = null;
  hsextafim:any = null;
  hsabadoinicio:any = null;
  hsabadofim:any = null;
  estab:any = null;

  constructor(public navCtrl: NavController, public navParams: NavParams, private toastCtrl: ToastController,
    private share: ShareService) {
    this.estab = this.navParams.get('estab');

  }

  validacao(){
    let valido = false;
    if(this.hdomingoinicio != null &&
      this.hdomingofim != null &&
      this.hsegundainicio != null &&
      this.hsegundafim != null &&
      this.htercainicio != null &&
      this.htercafim != null &&
      this.hquartainicio != null &&
      this.hquartafim != null &&
      this.hquintainicio != null &&
      this.hquintafim != null &&
      this.hsextainicio != null &&
      this.hsextafim != null &&
      this.hsabadoinicio != null &&
      this.hsabadofim != null){
        valido = true;

      }else{
        let toast = this.toastCtrl.create({
          message: "Preencha todos os campos.",
          duration: 2000
        });
        toast.present();
      }
      return valido;
  }

  finalizar(){
    if(this.validacao()){
      this.estab.hdomingoinicio = this.hdomingoinicio;
      this.estab.hdomingofim = this.hdomingofim;
      this.estab.hsegundainicio = this.hsegundainicio;
      this.estab.hsegundafim = this.hsegundafim;
      this.estab.htercainicio = this.htercainicio;
      this.estab.htercafim = this.htercafim;
      this.estab.hquartainicio = this.hquartainicio;
      this.estab.hquartafim = this.hquartafim;
      this.estab.hquintainicio = this.hquintainicio;
      this.estab.hquintafim = this.hquintafim;
      this.estab.hsextainicio = this.hsextainicio;
      this.estab.hsextafim = this.hsextafim;
      this.estab.hsabadoinicio = this.hsabadoinicio;
      this.estab.hsabadofim = this.hsabadofim;

      console.log(this.estab);

      this.share.cadastrarEstabelecimento(this.estab).subscribe((data:any)=>{
        if(data == 1){
          let toast = this.toastCtrl.create({
            message: "Estabelecimento cadastrado com sucesso.",
            duration: 2000
          });
          toast.present();
          this.navCtrl.push(LoginPage, {}, {animate: true});
        }else{
          let toast = this.toastCtrl.create({
            message: "Algo deu errado, verifique os campos.",
            duration: 2000
          });
          toast.present();
        }
      });
    }
  }

}
