import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams, ToastController } from 'ionic-angular';
import { ShareService } from '../share/share';

/**
 * Generated class for the NovaAvaliacaoPage page.
 *
 * See https://ionicframework.com/docs/components/#navigation for more info on
 * Ionic pages and navigation.
 */

@IonicPage()
@Component({
  selector: 'page-nova-avaliacao',
  templateUrl: 'nova-avaliacao.html',
})
export class NovaAvaliacaoPage {

  idestab: number = 0;
  nomeestab: string = null;
  pesquisa: string = null;
  resultadoPesquisa: any = [];
  notarefeicao: any = null;
  descrirefeicao: any = null;
  notaatendimento: any = null;
  descriatendimento: any = null;
  notaambiente: any = null;
  descriambiente: any = null;
  notapreco: any = null;
  descripreco: any = null;
  usuario: any = null;
  constructor(public navCtrl: NavController, public navParams: NavParams, private share: ShareService, private toastCtrl: ToastController) {
    this.usuario = this.navParams.get('usuario');
    this.retornaEstab();

  }

  retornaEstab() {
    this.share.retornaEstab().subscribe((data: any) => {
      this.resultadoPesquisa = [];

      data.forEach(x => {
        let estab = {
          nome: x.nome,
          id: x.id,
          foto: x.foto,
          tipoarquivo: 'png',
          fotourl: 'data:image/' + 'png' + ';base64,' + x.foto
        }
        this.resultadoPesquisa.push(estab);
      });
    });
  }

  valida() {
    if (this.notarefeicao == null || this.notaatendimento == null || this.notaambiente == null || this.notapreco == null) {
      let toast = this.toastCtrl.create({
        message: "Os campos de notas são obrigatórios.",
        duration: 2000
      });
      toast.present();
      return false;
    } else {
      return true;
    }
  }

  criarAvaliacao() {
    if (this.valida()) {
      this.share.criarAvaliacao(this.usuario.id, this.idestab, this.notarefeicao, this.descrirefeicao, this.notaatendimento, this.descriatendimento,
        this.notaambiente, this.descriambiente, this.notapreco, this.descripreco).subscribe((data: any) => {
          if (data == 1) {
            let toast = this.toastCtrl.create({
              message: "Avaliação criada com sucesso.",
              duration: 2000
            });
            toast.present();
            this.navCtrl.pop();
          } else {
            let toast = this.toastCtrl.create({
              message: "Algo deu errado.",
              duration: 2000
            });
            toast.present();
          }
        });
    }
  }


  verificaNota(tipo) {
    if (tipo == 'refeicao') {
      if (Number(this.notarefeicao) > 50) {
        this.notarefeicao = '5.0';
      }
    }
    if (tipo == 'atend') {
      if (Number(this.notaatendimento) > 50) {
        this.notaatendimento = '5.0';
      }
    }
    if (tipo == 'ambiente') {
      if (Number(this.notaambiente) > 50) {
        this.notaambiente = '5.0';
      }
    }
    if (tipo == 'preco') {
      if (Number(this.notapreco) > 50) {
        this.notapreco = '5.0';
      }
    }

  }

  novaPesquisa() {
    this.idestab = 0;
    this.nomeestab = null;
  }

  escolheEstab(id) {
    this.idestab = id;
    this.nomeestab = this.resultadoPesquisa.find(x => x.id == id).nome;
  }

  pesquisaNome() {
    if (this.pesquisa == "") {
      this.retornaEstab();
    } else {
      this.share.retornaPesquisaEstabelecimentoPorNome(this.pesquisa).subscribe((data: any) => {
        this.resultadoPesquisa = [];

        data.forEach(x => {
          let estab = {
            nome: x.nome,
            id: x.id,
            foto: x.foto,
            tipoarquivo: 'png',
            fotourl: 'data:image/' + 'png' + ';base64,' + x.foto
          }
          this.resultadoPesquisa.push(estab);
        });
      });
    }
  }

}
