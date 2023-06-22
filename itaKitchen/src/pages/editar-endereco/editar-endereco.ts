import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams, ToastController } from 'ionic-angular';
import { ShareService } from '../share/share';

/**
 * Generated class for the EditarEnderecoPage page.
 *
 * See https://ionicframework.com/docs/components/#navigation for more info on
 * Ionic pages and navigation.
 */

@IonicPage()
@Component({
  selector: 'page-editar-endereco',
  templateUrl: 'editar-endereco.html',
})
export class EditarEnderecoPage {
  cep: any = null;
  rua: any = null;
  numero: any = null;
  bairro: any = null;
  complemento: any = null;
  enderecoantigo: any = null;
  campos: string = "";
  valores: string = "";

  constructor(public navCtrl: NavController, public navParams: NavParams, private toastCtrl: ToastController,
    private share: ShareService) {
    this.enderecoantigo = this.navParams.get('endereco');
    this.cep = this.enderecoantigo.textocep;
    this.rua = this.enderecoantigo.rua;
    this.numero = this.enderecoantigo.numero;
    this.bairro = this.enderecoantigo.bairro;
    this.complemento = this.enderecoantigo.complemento;

  }

  verificaCep() {
    if (this.cep.length == 9 && this.containsOnlyNumbers(this.cep.replaceAll('-', '')) == true) {
      try {
        this.share.verificarCep(this.cep.replaceAll('-', '')).subscribe((data: any) => {
          
          if (data.erro == undefined) {
            console.log(data);
            this.rua = data.logradouro;
            this.complemento = data.complemento;
            this.bairro = data.bairro;
          }
        });
      } catch {

      }
    }
  }


  containsOnlyNumbers(str: string): boolean {
    return !isNaN(Number(str));
  }

  validacao() {
    let valido = false;

    console.log(this.cep);
    if (this.cep != null && this.rua != null && this.bairro != null && this.numero != null) {
      let cepvalida = this.cep.replaceAll('-', '');
      if (this.cep.length == 9 && this.containsOnlyNumbers(cepvalida) == true) {

        if (this.containsOnlyNumbers(this.numero) == true) {
          valido = true;

          if (this.cep != this.enderecoantigo.textocep) {
            this.campos += 'cep,';
            this.valores += cepvalida + ','
          }

          if (this.rua != this.enderecoantigo.rua) {
            this.campos += 'rua,';
            this.valores += this.rua + ','
          }
          if (this.bairro != this.enderecoantigo.bairro) {
            this.campos += 'bairro,';
            this.valores += this.bairro + ','
          }

          if (this.numero != this.enderecoantigo.numero) {
            this.campos += 'numero,';
            this.valores += this.numero + ','
          }
          if (this.complemento != this.enderecoantigo.complemento) {
            this.campos += 'complem,';
            this.valores += this.complemento + ','
          }
        } else {
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

  editarEndereco() {
    if (this.validacao() && this.campos != "") {
      this.share.editarEndereco(this.enderecoantigo.id, this.campos, this.valores).subscribe((data: any) => {
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
