import { Component } from '@angular/core';
import { ActionSheetController, IonicPage, NavController, NavParams } from 'ionic-angular';
import { UsuarioPage } from '../usuario/usuario';
import { MinhasAvaliacoesPage } from '../minhas-avaliacoes/minhas-avaliacoes';
import { ShareService } from '../share/share';
import { NovaAvaliacaoPage } from '../nova-avaliacao/nova-avaliacao';
import { EstabAvaliacoesPage } from '../estab-avaliacoes/estab-avaliacoes';
import { VerAvaliacaoPage } from '../ver-avaliacao/ver-avaliacao';

/**
 * Generated class for the InicioPage page.
 *
 * See https://ionicframework.com/docs/components/#navigation for more info on
 * Ionic pages and navigation.
 */

@IonicPage()
@Component({
  selector: 'page-inicio',
  templateUrl: 'inicio.html',
})
export class InicioPage {

  clienteOuEstab: any = 0; //0 Cliente - 1 Estabelecimento 
  usuario: any;
  estabelecimentos: any = [];
  avaliacoes: any = [];
  categorias: any = [];
  filtrar: any = false;
  categoria: any = 0;
  pesquisa: any = "";
  pesquisarEstab: any = false;


  constructor(public navCtrl: NavController, public navParams: NavParams, private share: ShareService, private actionSheetCtrl: ActionSheetController) {

    this.usuario = this.navParams.get("usuario");

  }

  ionViewWillEnter() {
    this.pesquisarEstab = false;
    if (this.usuario.cpf != undefined) {
      this.clienteOuEstab = 0;
      this.estabelecimentos = [];
      this.carregarEstabelecimentos();
    } else {
      this.clienteOuEstab = 1;
      this.carregarAvaliacoes();
    }
  }

  mostraPesquisar() {
    if (this.pesquisarEstab == true) {
      this.pesquisarEstab = false;
    } else {
      this.pesquisarEstab = true;
      this.filtrar = false;
    }
  }

  pesquisaNome() {
    if (this.pesquisa == "") {
      this.carregarEstabelecimentos();
    } else {
      this.share.retornaPesquisaEstabelecimentoPorNome(this.pesquisa).subscribe((data: any) => {
        this.estabelecimentos = [];
        data.forEach(x => {
          let estab = {
            id: x.id,
            nome: x.nome,
            cnpj: x.cnpj,
            contato: x.contato,
            foto: x.foto,
            idendereco: data[0].idEndereco,
            idhorariofunc: data[0].idHorario,
            idcategoria: data[0].idCategoria,
            tipoarquivo: 'jpeg',
            numavaliacoes: 0,
            nota: 0,
            fotourl: 'data:image/' + 'png' + ';base64,' + x.foto
          }

          this.estabelecimentos.push(estab);

        });

        this.estabelecimentos.forEach(x => {
          this.share.retornaNumAvaliacoesPorEstab(x.id).subscribe((data2: any) => {

            x.numavaliacoes = data2[0][0];
            x.nota = data2[0][1];
          });
        });
      });
    }
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
    });
  }

  filtrarBt() {
    if (this.filtrar == true) {
      this.filtrar = false;
    } else {
      this.retornaCategorias();
      this.filtrar = true;
      this.pesquisarEstab = false;
    }
  }

  filtrarPorCategoria() {
    if (this.categoria == 0) {
      this.carregarEstabelecimentos();
      this.filtrarBt();
    } else {
      this.share.filtrarEstabPorCategoria(this.categoria).subscribe((data: any) => {
        this.estabelecimentos = [];
        data.forEach(x => {
          let estab = {
            id: x.id,
            nome: x.nome,
            cnpj: x.cnpj,
            contato: x.contato,
            foto: x.foto,
            idendereco: data[0].idEndereco,
            idhorariofunc: data[0].idHorario,
            idcategoria: data[0].idCategoria,
            tipoarquivo: 'jpeg',
            numavaliacoes: 0,
            nota: 0,
            fotourl: 'data:image/' + 'png' + ';base64,' + x.foto
          }

          this.estabelecimentos.push(estab);

        });

        this.estabelecimentos.forEach(x => {
          this.share.retornaNumAvaliacoesPorEstab(x.id).subscribe((data2: any) => {

            x.numavaliacoes = data2[0][0];
            x.nota = data2[0][1];
          });
        });
      });
    }
  }

  ordenarBt() {
    const actionSheet = this.actionSheetCtrl.create({
      title: 'Ordenar por:',
      buttons: [
        {
          text: 'Nome',
          handler: () => {
            this.ordenaEstabs('nome');
          }
        }, {
          text: 'Melhores avaliados',
          handler: () => {
            this.ordenaEstabs('nota');
          }
        }, {
          text: 'Mais avaliações',
          handler: () => {
            this.ordenaEstabs('numeroAval');
          }
        }
      ]
    });
    actionSheet.present();
  }

  ordenaEstabs(tipo) {
    if (tipo == 'nome') {
      this.estabelecimentos.sort((a, b) => a.nome.localeCompare(b.nome));
    } else if (tipo == 'nota') {
      this.estabelecimentos.sort(this.compararPorNota);
    } else if (tipo == 'numeroAval') {
      this.estabelecimentos.sort(this.compararPorNumAvaliacoes);
    }
  }

  compararPorNota(a, b) {
    if (a.nota < b.nota) {
      return 1;
    } else if (a.nota > b.nota) {
      return -1;
    } else {
      return 0;
    }
  }

  compararPorNumAvaliacoes(a, b) {
    if (a.numavaliacoes < b.numavaliacoes) {
      return 1;
    } else if (a.numavaliacoes > b.numavaliacoes) {
      return -1;
    } else {
      return 0;
    }
  }

  verAvaliacao(id) {
    let aval = this.avaliacoes.find(x => x.id == id);
    this.navCtrl.push(VerAvaliacaoPage, { avaliacao: aval, usuario: this.usuario, excluir: false }, { animate: true });
  }

  verEstab(id) {
    this.navCtrl.push(EstabAvaliacoesPage, { idestab: id, usuario: this.usuario }, { animate: true });
  }

  carregarAvaliacoes() {
    this.share.retornaAvaliacoesEstab(this.usuario.id).subscribe((data: any) => {
      this.avaliacoes = [];
      console.log(data);
      data.forEach(x => {
        let avaliacao = {
          id: x.id,
          idcli: x.idCli,
          idestab: x.idEstab,
          nomeestab: this.usuario.nome,
          media: x.media,
          notarefeicao: x.notaRefeicao,
          descrirefeicao: x.descriRefeicao,
          notaatendimento: x.notaAtendimento,
          descriatendimento: x.descriAtendimento,
          notaambiente: x.notaAmbiente,
          descriambiente: x.descriAmbiente,
          notapreco: x.notaPreco,
          descripreco: x.descriPreco,
          data: x.dataeHora,
        }

        this.avaliacoes.push(avaliacao);

      });
    });
  }

  novaAvaliacao() {
    this.navCtrl.push(NovaAvaliacaoPage, { usuario: this.usuario });
  }

  acessarPerfil() {
    this.navCtrl.push(UsuarioPage, { usuario: this.usuario, clienteOuEstab: this.clienteOuEstab },
      { animate: true });
  }

  minhasAvaliacoes() {
    this.navCtrl.push(MinhasAvaliacoesPage, { usuario: this.usuario, clienteOuEstab: this.clienteOuEstab },
      { animate: true });
  }



  sair() {
    this.navCtrl.pop();
  }

  carregarEstabelecimentos() {
    this.share.retornaEstab().subscribe((data: any) => {
      this.estabelecimentos = [];
      data.forEach(x => {
        let estab = {
          id: x.id,
          nome: x.nome,
          cnpj: x.cnpj,
          contato: x.contato,
          foto: x.foto,
          idendereco: data[0].idEndereco,
          idhorariofunc: data[0].idHorario,
          idcategoria: data[0].idCategoria,
          tipoarquivo: 'jpeg',
          numavaliacoes: 0,
          nota: 0,
          fotourl: 'data:image/' + 'png' + ';base64,' + x.foto
        }

        this.estabelecimentos.push(estab);

      });

      this.estabelecimentos.forEach(x => {
        this.share.retornaNumAvaliacoesPorEstab(x.id).subscribe((data2: any) => {

          x.numavaliacoes = data2[0][0];
          x.nota = data2[0][1];
        });
      });
    });
  }



}
