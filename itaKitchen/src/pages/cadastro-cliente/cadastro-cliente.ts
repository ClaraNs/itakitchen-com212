import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams, ToastController } from 'ionic-angular';
import { ShareService } from '../share/share';
import { LoginPage } from '../login/login';
import { DatePipe } from '@angular/common';

/**
 * Generated class for the CadastroClientePage page.
 *
 * See https://ionicframework.com/docs/components/#navigation for more info on
 * Ionic pages and navigation.
 */

@IonicPage()
@Component({
  selector: 'page-cadastro-cliente',
  templateUrl: 'cadastro-cliente.html',
})
export class CadastroClientePage {


  tiposCliente: any = [
    { id: 'Morador', descri: 'Morador' },
    { id: 'Estudante', descri: 'Estudante' },
    { id: 'Republica', descri: 'Rebública' }
  ];
  pipe: any = new DatePipe('en-US');
  email: any;
  senha: any;
  nome: any = null;
  cpf: any = null;
  datanas: any = null;
  tipocli: any = null;
  img: any = null;
  nomearq:any = "Enviar foto de perfil...";


  constructor(public navCtrl: NavController, public navParams: NavParams, private toastCtrl: ToastController,
    private share: ShareService) {
    this.email = this.navParams.get("email");
    this.senha = this.navParams.get("senha");

  }



  containsOnlyNumbers(str: string): boolean {
    return !isNaN(Number(str));
  }

  validacao() {
    console.log(this.img);
    let valido = false;

    if (this.nome != null && this.cpf != null && this.datanas != null && this.tipocli != null) {
      let cpfvalida = this.cpf.replaceAll('.', '');
      cpfvalida = cpfvalida.replaceAll('-', '');
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
    } else {
      let toast = this.toastCtrl.create({
        message: "Preenche todos os campos.",
        duration: 2000
      });
      toast.present();
    }

    return valido;
  }

  cadastrarCliente() {
  
    if (this.validacao()) {
      let cpfvalida = this.cpf.replaceAll('.', '');
      cpfvalida = cpfvalida.replaceAll('-', '');
      let datanasformat = this.pipe.transform(this.datanas, 'yyyy-MM-dd');
      this.share.cadastrarCliente(this.email, this.senha, this.nome,
        cpfvalida, datanasformat, this.img, this.tipocli).subscribe((data: any) => {
          console.log(data);
          if (data == 1) {
            let toast = this.toastCtrl.create({
              message: "Seu cadastro foi concluído!",
              duration: 2000
            });
            toast.present();
            this.navCtrl.push(LoginPage, {}, { animate: true });
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
      //const arrayBuffer = reader.result as ArrayBuffer;
      //const bytes = new Uint8Array(arrayBuffer);
      //const bytea = this.arrayBufferToBytea(bytes);
      const base64 = reader.result as string;
      this.img = base64;
      console.log(this.img);
      //this.img = bytea;
    };

    //reader.readAsArrayBuffer(file);
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
