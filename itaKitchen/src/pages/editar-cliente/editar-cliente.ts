import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams, ToastController } from 'ionic-angular';
import { ShareService } from '../share/share';
import { DatePipe } from '@angular/common';

/**
 * Generated class for the EditarClientePage page.
 *
 * See https://ionicframework.com/docs/components/#navigation for more info on
 * Ionic pages and navigation.
 */

@IonicPage()
@Component({
  selector: 'page-editar-cliente',
  templateUrl: 'editar-cliente.html',
})
export class EditarClientePage {

  tiposCliente: any = [
    { id: 'Morador', descri: 'Morador' },
    { id: 'Estudante', descri: 'Estudante' },
    { id: 'Republica', descri: 'Rebública' }
  ];
  pipe: any = new DatePipe('en-US');
  email: any;
  senha: any = null;
  nome: any = null;
  cpf: any = null;
  datanas: any = null;
  tipocli: any = null;
  img: any = null;
  nomearq:any = "Nova foto de perfil...";
  usuarioantigo:any;
  campos:any = "";
  valores:any = "";


  constructor(public navCtrl: NavController, public navParams: NavParams, private toastCtrl: ToastController,
    private share: ShareService) {
    this.usuarioantigo = this.navParams.get("usuario");
    this.email = this.usuarioantigo.email;
    this.nome = this.usuarioantigo.nome;
    this.cpf = this.usuarioantigo.cpf;
    this.datanas = this.usuarioantigo.datanas;
    this.tipocli = this.usuarioantigo.tipo;

  }



  containsOnlyNumbers(str: string): boolean {
    return !isNaN(Number(str));
  }

  validacao() {
    this.campos = "";
    this.valores = "";
    let valido = false;
    if(this.cpf != this.usuarioantigo.cpf && this.cpf != null){
      this.campos += "cpf,";
      let cpfvalida = this.cpf.replaceAll('.', '');
      cpfvalida = cpfvalida.replaceAll('-', '');
      this.valores += cpfvalida + "!";
      console.log(this.containsOnlyNumbers(cpfvalida));
      if (this.cpf.length == 14 && this.containsOnlyNumbers(cpfvalida) == true) {
        valido = true;
      } else {
        let toast = this.toastCtrl.create({
          message: "O CPF deve estar preenchido corretamente.",
          duration: 2000
        });
        toast.present();
      }
    }

    if(this.email != this.usuarioantigo.email && this.email != null){
    
        if (this.email.includes('@') && this.email.split('@')[1] != '') {
          this.campos += "email,";
          this.valores += this.email + "!";
          valido = true;
        } else {
          let toast = this.toastCtrl.create({
            message: "O e-mail deve conter um '@' e uma parte depois do '@'.",
            duration: 2000
          });
          toast.present();
        }
    }

    if(this.nome != this.usuarioantigo.nome){
      valido = true;
      this.campos += "nome,";
      this.valores += this.nome + "!";
    }

    if(this.datanas != this.usuarioantigo.dataNascimento){
      valido = true;
      this.campos += "dataNascimento,";
      let datanasformat = this.pipe.transform(this.datanas, 'yyyy-MM-dd');
      this.valores += datanasformat + "!";
    }

    if(this.tipocli != this.usuarioantigo.tipo){
      valido = true;
      this.campos += "tipo,";
      this.valores += this.tipocli + "!";
    }
    
    return valido;
  }

  editarCliente() {
  
    if (this.validacao()) {
      this.share.editarCliente(this.usuarioantigo.id, this.campos, this.valores).subscribe((data: any) => {
          console.log(data);
          if (data == 1) {
            let toast = this.toastCtrl.create({
              message: "Os dados foram editados com sucesso!",
              duration: 2000
            });
            toast.present();
            this.navCtrl.pop();
          } else {
            let toast = this.toastCtrl.create({
              message: "Algo deu errado, verifique os campos.",
              duration: 2000
            });
            toast.present();
          }
        });
    }
  }



  processFile(event) {
    const file = event.target.files[0];
    this.nomearq = file.name;
    const reader = new FileReader();

    reader.onloadend = () => {
      const base64 = reader.result as string;
      this.img = base64;
    };

    reader.readAsDataURL(file);
  }

  arrayBufferToBytea(buffer: Uint8Array): string {
    let bytea = '';
    for (let i = 0; i < buffer.length; i++) {
      bytea += String.fromCharCode(buffer[i]);
    }
    return bytea;
  }


}
