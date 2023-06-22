import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams, ToastController } from 'ionic-angular';
import { ShareService } from '../share/share';

/**
 * Generated class for the EditarHorarioPage page.
 *
 * See https://ionicframework.com/docs/components/#navigation for more info on
 * Ionic pages and navigation.
 */

@IonicPage()
@Component({
  selector: 'page-editar-horario',
  templateUrl: 'editar-horario.html',
})
export class EditarHorarioPage {
  hdomingoinicio: any = null;
  hdomingofim: any = null;
  hsegundainicio: any = null;
  hsegundafim: any = null;
  htercainicio: any = null;
  htercafim: any = null;
  hquartainicio: any = null;
  hquartafim: any = null;
  hquintainicio: any = null;
  hquintafim: any = null;
  hsextainicio: any = null;
  hsextafim: any = null;
  hsabadoinicio: any = null;
  hsabadofim: any = null;
  horarioantigo: any = null;
  campos:string = "";
  valores:string = "";

  constructor(public navCtrl: NavController, public navParams: NavParams, private toastCtrl: ToastController,
    private share: ShareService) {
    this.horarioantigo = this.navParams.get('horario');
    this.hdomingoinicio = this.horarioantigo.hdomingoinicio;
    this.hdomingofim = this.horarioantigo.hdomingofim;
    this.hsegundainicio = this.horarioantigo.hsegundainicio;
    this.hsegundafim = this.horarioantigo.hsegundafim;
    this.htercainicio = this.horarioantigo.htercainicio;
    this.htercafim = this.horarioantigo.htercafim;
    this.hquartainicio = this.horarioantigo.hquartainicio;
    this.hquartafim = this.horarioantigo.hquartafim;
    this.hquintainicio = this.horarioantigo.hquintainicio;
    this.hquintafim = this.horarioantigo.hquintafim;
    this.hsextainicio = this.horarioantigo.hsextainicio;
    this.hsextafim = this.horarioantigo.hsextafim;
    this.hsabadoinicio = this.horarioantigo.hsabadoinicio;
    this.hsabadofim = this.horarioantigo.hsabadofim;

  }

  validacao() {
    let valido = false;
    if (this.hdomingoinicio != null &&
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
      this.hsabadofim != null) {
      valido = true;

      if(this.hdomingoinicio != this.horarioantigo.hdomingoinicio){
        this.campos += 'hdomingoinicio,';
        this.valores += this.hdomingoinicio + ',';
      }
      if(this.hdomingofim != this.horarioantigo.hdomingofim){
        this.campos += 'hdomingofim,';
        this.valores += this.hdomingofim + ',';
      }

      if(this.hsegundainicio != this.horarioantigo.hsegundainicio){
        this.campos += 'hsegundainicio,';
        this.valores += this.hsegundainicio + ',';
      }
      if(this.hsegundafim != this.horarioantigo.hsegundafim){
        this.campos += 'hsegundafim,';
        this.valores += this.hsegundafim + ',';
      }

      if(this.htercainicio != this.horarioantigo.htercainicio){
        this.campos += 'htercainicio,';
        this.valores += this.htercainicio + ',';
      }
      if(this.htercafim != this.horarioantigo.htercafim){
        this.campos += 'htercafim,';
        this.valores += this.htercafim + ',';
      }

      if(this.hquartainicio != this.horarioantigo.hquartainicio){
        this.campos += 'hquartainicio,';
        this.valores += this.hquartainicio + ',';
      }
      if(this.hquartafim != this.horarioantigo.hquartafim){
        this.campos += 'hquartafim,';
        this.valores += this.hquartafim + ',';
      }

      if(this.hquintainicio != this.horarioantigo.hquintainicio){
        this.campos += 'hquintainicio,';
        this.valores += this.hquintainicio + ',';
      }
      if(this.hquintafim != this.horarioantigo.hquintafim){
        this.campos += 'hquintafim,';
        this.valores += this.hquintafim + ',';
      }

      if(this.hsextainicio != this.horarioantigo.hsextainicio){
        this.campos += 'hsextainicio,';
        this.valores += this.hsextainicio + ',';
      }
      if(this.hsextafim != this.horarioantigo.hsextafim){
        this.campos += 'hsextafim,';
        this.valores += this.hsextafim + ',';
      }

      if(this.hsabadoinicio != this.horarioantigo.hsabadoinicio){
        this.campos += 'hsabadoinicio,';
        this.valores += this.hsabadoinicio + ',';
      }
      if(this.hsabadofim != this.horarioantigo.hsabadofim){
        this.campos += 'hsabadofim,';
        this.valores += this.hsabadofim + ',';
      }


    } else {
      let toast = this.toastCtrl.create({
        message: "Preencha todos os campos.",
        duration: 2000
      });
      toast.present();
    }
    return valido;
  }

  editarHorario() {
    if (this.validacao() && this.campos != "") {
      this.share.editarHorario(this.horarioantigo.id, this.campos, this.valores).subscribe((data: any) => {
        if (data == 1) {
          let toast = this.toastCtrl.create({
            message: "Dados atualizados com sucesso!",
            duration: 2000
          });
          toast.present();
          this.navCtrl.pop();
        } else {
          let toast = this.toastCtrl.create({
            message: "Algo deu errado...",
            duration: 2000
          });
          toast.present();
        }
      });
    }
  }

}
