import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams } from 'ionic-angular';
import { ShareService } from '../share/share';
import { VerAvaliacaoPage } from '../ver-avaliacao/ver-avaliacao';
import { UsuarioPage } from '../usuario/usuario';
import { MinhasAvaliacoesPage } from '../minhas-avaliacoes/minhas-avaliacoes';
import { NovaAvaliacaoPage } from '../nova-avaliacao/nova-avaliacao';
import { InicioPage } from '../inicio/inicio';
import { InformacoesEstabPage } from '../informacoes-estab/informacoes-estab';

/**
 * Generated class for the EstabAvaliacoesPage page.
 *
 * See https://ionicframework.com/docs/components/#navigation for more info on
 * Ionic pages and navigation.
 */

@IonicPage()
@Component({
  selector: 'page-estab-avaliacoes',
  templateUrl: 'estab-avaliacoes.html',
})
export class EstabAvaliacoesPage {

  avaliacoes: any = [];
  idestab:any = null;
  estab: any = null;
  usuario:any = null;

  constructor(public navCtrl: NavController, public navParams: NavParams, private share:ShareService) {
    this.idestab = this.navParams.get('idestab');
    this.usuario = this.navParams.get("usuario");
    this.carregarEstabelecimento();
  }

  ionViewWillEnter() {
    this.carregarAvaliacoes();
  }

  infos(){
    this.navCtrl.push(InformacoesEstabPage, {idestab: this.idestab, usuario: this.usuario}, {animate: true});
  }

  novaAvaliacao(){
    this.navCtrl.push(NovaAvaliacaoPage, {usuario: this.usuario});
  }

  menu(){
    this.navCtrl.push(InicioPage, { usuario: this.usuario },
      { animate: true });
  }

  acessarPerfil() {
    this.navCtrl.push(UsuarioPage, { usuario: this.usuario, clienteOuEstab: 0 },
      { animate: true });
  }

  minhasAvaliacoes() {
    this.navCtrl.push(MinhasAvaliacoesPage, { usuario: this.usuario, clienteOuEstab: 0 },
      { animate: true });
  }

  verAvaliacao(id){
    let aval = this.avaliacoes.find(x=> x.id == id);
    this.navCtrl.push(VerAvaliacaoPage, {avaliacao: aval, excluir: false}, {animate: true});
  }

  carregarAvaliacoes(){
    this.share.retornaAvaliacoesEstab(this.idestab).subscribe((data:any)=>{
      this.avaliacoes = [];
      console.log(data);
      data.forEach(x => {
        let avaliacao = {
          id: x.id,
          idcli: x.idCli,
          idestab: x.idEstab,
          nomeestab: "",
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
      this.avaliacoes.forEach(x=>{
        this.share.retornaEstabelecimentoPorID(x.idestab).subscribe((datas:any)=>{
          x.nomeestab = datas[0].nome;
        });
        
      });
    });
  }

  carregarEstabelecimento() {
    this.share.retornaEstabelecimentoPorID(this.idestab).subscribe((data: any) => {
      console.log(data[0].id)
      this.share.retornaNumAvaliacoesPorEstab(data[0].id).subscribe((data2: any) => {

        let estab = {
          id: data[0].id,
          nome: data[0].nome,
          cnpj: data[0].cnpj,
          contato: data[0].contato,
          foto: data[0].foto,
          idendereco: data[0].idEndereco,
          idhorariofunc: data[0].idHorario,
          idcategoria: data[0].idCategoria,
          tipoarquivo: 'jpeg',
          numavaliacoes: data2[0][0],
          nota: data2[0][1],
          fotourl: 'data:image/' + 'png' + ';base64,' + data[0].foto
        }

        this.estab = estab;
      });

    });
  }

}
