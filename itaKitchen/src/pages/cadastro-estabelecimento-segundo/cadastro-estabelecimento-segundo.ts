import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams, ToastController } from 'ionic-angular';
import { createParameter } from 'typescript';
import { ShareService } from '../share/share';
import { CadastroHorariosPage } from '../cadastro-horarios/cadastro-horarios';

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

  cep:any = null;
  rua:any = null;
  numero:any = null;
  bairro:any = null;
  complemento:any = null;
  estab:any = null;

  constructor(public navCtrl: NavController, public navParams: NavParams, private toastCtrl: ToastController,
    private share: ShareService) {
    this.estab = this.navParams.get('estab');

  }

  verificaCep(){
    if(this.cep.length == 9 && this.containsOnlyNumbers(this.cep.replaceAll('-', '')) == true){
      try{
      this.share.verificarCep(this.cep.replaceAll('-', '')).subscribe((data:any)=>{
        this.rua = data.logradouro;
        this.complemento = data.complemento;
        this.bairro = data.bairro;
      });
    }catch{

    }
    }
  }

  
  containsOnlyNumbers(str: string): boolean {
    return !isNaN(Number(str));
  }

  validacao() {
    let valido = false;

    if (this.cep != null && this.rua != null && this.bairro != null && this.numero != null ) {
      let cepvalida = this.cep.replaceAll('-', '');
      if (this.cep.length == 9 && this.containsOnlyNumbers(cepvalida) == true) {
        
        if(this.containsOnlyNumbers(this.numero) == true){
          valido = true;
        }else{
          let toast = this.toastCtrl.create({
            message: "O número deve conter apenas caracteres numéricos.",
            duration: 2000
          });
          toast.present();
        }
      } else {
        let toast = this.toastCtrl.create({
          message: "O CEP deve estar preenchido corretamente.",
          duration: 2000
        });
        toast.present();
      }
    } else {
      let toast = this.toastCtrl.create({
        message: "Os campos CEP, rua, bairro e número são obrigatórios.",
        duration: 2000
      });
      toast.present();
    }

    return valido;
  }

  cadastrarEstabelecimento() {
    
    if (this.validacao()) {
      this.estab.rua = this.rua;
      this.estab.bairro = this.bairro;
      this.estab.numero = this.numero;
      this.estab.cep = this.cep.replaceAll("-", "");
      this.estab.complemento = this.complemento;
      this.navCtrl.push(CadastroHorariosPage, {estab: this.estab}, { animate: true });
          
    }
  }
}
