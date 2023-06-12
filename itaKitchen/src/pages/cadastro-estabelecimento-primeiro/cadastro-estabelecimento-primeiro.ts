import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams, ToastController } from 'ionic-angular';
import { ShareService } from '../share/share';
import { DatePipe } from '@angular/common';
import { CadastroEstabelecimentoSegundoPage } from '../cadastro-estabelecimento-segundo/cadastro-estabelecimento-segundo';

/**
 * Generated class for the CadastroEstabelecimentoPrimeiroPage page.
 *
 * See https://ionicframework.com/docs/components/#navigation for more info on
 * Ionic pages and navigation.
 */

@IonicPage()
@Component({
  selector: 'page-cadastro-estabelecimento-primeiro',
  templateUrl: 'cadastro-estabelecimento-primeiro.html',
})
export class CadastroEstabelecimentoPrimeiroPage {

  categorias: any = [];
  pipe: any = new DatePipe('en-US');
  email: any;
  senha: any;
  nome: any = null;
  cnpj: any = null;
  categoria: any = null;
  img: any = null;
  nomearq: any = "Enviar logo...";
  contato: any = null;
  cnpjformatado: any;
  descricao:any = null;

  constructor(public navCtrl: NavController, public navParams: NavParams, private toastCtrl: ToastController,
    private share: ShareService) {
    this.email = this.navParams.get("email");
    this.senha = this.navParams.get("senha");
    this.retornaCategorias();

  }

  retornaCategorias() {
    this.share.retornaCategorias().subscribe((data:any)=>{
      this.categorias = [];
      data.forEach(x => {
        let cat = {
          id: x.id,
          descri: x.descricao
        }        

        this.categorias.push(cat);
      });
    });
  }



  containsOnlyNumbers(str: string): boolean {
    return !isNaN(Number(str));
  }

  validacao() {
    console.log(this.img);
    let valido = false;

    if (this.nome != null && this.cnpj != null && this.contato != null && this.categoria != null) {
      let cnpjvalida = this.cnpj.replaceAll('.', '');
      cnpjvalida = cnpjvalida.replaceAll('-', '');
      cnpjvalida = cnpjvalida.replaceAll('/', '');
      this.cnpjformatado = cnpjvalida;
      console.log(this.containsOnlyNumbers(cnpjvalida));
      if (this.cnpj.length == 18 && this.containsOnlyNumbers(cnpjvalida) == true) {
        let celularvalido = this.contato.replaceAll('(', "");
        celularvalido = celularvalido.replaceAll(')', "");
        celularvalido = celularvalido.replaceAll('-', "");
        celularvalido = celularvalido.replaceAll(' ', "");
        if(this.contato.length >= 14 && this.containsOnlyNumbers(celularvalido) == true){
          valido = true;
          console.log(valido);
        }else{
          let toast = this.toastCtrl.create({
            message: "O celular para contato deve estar preenchido corretamente.",
            duration: 2000
          });
          toast.present();
        }
      } else {
        let toast = this.toastCtrl.create({
          message: "O CNPJ deve estar preenchido corretamente.",
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

    return valido;
  }

  cadastrarEstabelecimento() {
    
    if (this.validacao()) {
      let estab = {
        nome: this.nome,
        email: this.email,
        senha: this.senha,
        contato: this.contato,
        cnpj: this.cnpjformatado,
        foto: this.img,
        categoria: this.categoria,
        descricao: this.descricao,

      }
      this.navCtrl.push(CadastroEstabelecimentoSegundoPage, {estab: estab}, { animate: true });
          
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
