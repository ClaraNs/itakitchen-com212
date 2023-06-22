import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams, ToastController } from 'ionic-angular';
import { ShareService } from '../share/share';
import { DatePipe } from '@angular/common';

/**
 * Generated class for the EditarEstabPage page.
 *
 * See https://ionicframework.com/docs/components/#navigation for more info on
 * Ionic pages and navigation.
 */

@IonicPage()
@Component({
  selector: 'page-editar-estab',
  templateUrl: 'editar-estab.html',
})
export class EditarEstabPage {

  categorias: any = [];
  pipe: any = new DatePipe('en-US');
  email: any;
  senha: any;
  nome: any = null;
  cnpj: any = null;
  categoria: any = null;
  contato: any = null;
  cnpjformatado: any;
  descricao: any = null;
  estabantigo: any;
  campos: any = "";
  estab: any = null;
  valores: any = "";

  constructor(public navCtrl: NavController, public navParams: NavParams, private toastCtrl: ToastController,
    private share: ShareService) {
    this.estabantigo = this.navParams.get('estab');
    this.nome = this.estabantigo.nome;
    this.cnpj = this.formatarCNPJ(this.estabantigo.cnpj);
    this.contato = this.estabantigo.contato;
    this.descricao = this.estabantigo.descricao
    this.retornaCategorias();

  }

  formatarCNPJ(cnpj: string): string {
    return cnpj.replace(/^(\d{2})(\d{3})(\d{3})(\d{4})(\d{2})$/, '$1.$2.$3/$4-$5');
  }



  retornaCategorias() {
    this.share.retornaCategorias().subscribe((data: any) => {
      this.categorias = [];
      data.forEach(x => {
        let cat = {
          id: x.id,
          descri: x.descricao
        }

        this.categorias.push(cat);
      });
      this.categoria = this.estabantigo.idcategoria;
    });
  }



  containsOnlyNumbers(str: string): boolean {
    return !isNaN(Number(str));
  }

  validacao() {
    this.campos = "";
    this.valores = "";
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
        if (this.contato.length >= 14 && this.containsOnlyNumbers(celularvalido) == true) {
          valido = true;
          console.log('oi');

          if (this.nome != this.estabantigo.nome) {
            this.campos += 'nome,';
            this.valores += this.nome + ',';
          }

          if (this.cnpjformatado != this.estabantigo.cnpj) {
            this.campos += 'cnpj,';
            this.valores += this.cnpjformatado + ',';
          }
          if (this.contato != this.estabantigo.contato) {
            this.campos += 'contato,';
            this.valores += this.contato + ',';
          }
          if (this.descricao != this.estabantigo.descricao) {
            this.campos += 'descricao,';
            this.valores += this.descricao + ',';
          }
          if (this.categoria != this.estabantigo.idcategoria) {
            this.campos += 'idcategoria,';
            this.valores += this.categoria + ',';
          }
        } else {
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
        message: "Todos os campos obrigatóros devem estar preenchidos.",
        duration: 2000
      });
      toast.present();
    }

    return valido;
  }

  editarEstab() {
    if (this.validacao() && this.campos != "") {
      this.share.editarEstab(this.estabantigo.id, this.campos, this.valores).subscribe((data: any) => {
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
