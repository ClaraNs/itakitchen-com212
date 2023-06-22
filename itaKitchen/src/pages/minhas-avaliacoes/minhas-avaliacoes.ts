import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams } from 'ionic-angular';
import { UsuarioPage } from '../usuario/usuario';
import { InicioPage } from '../inicio/inicio';
import { NovaAvaliacaoPage } from '../nova-avaliacao/nova-avaliacao';
import { ShareService } from '../share/share';
import { VerAvaliacaoPage } from '../ver-avaliacao/ver-avaliacao';

/**
 * Generated class for the MinhasAvaliacoesPage page.
 *
 * See https://ionicframework.com/docs/components/#navigation for more info on
 * Ionic pages and navigation.
 */

@IonicPage()
@Component({
  selector: 'page-minhas-avaliacoes',
  templateUrl: 'minhas-avaliacoes.html',
})
export class MinhasAvaliacoesPage {

  usuario:any;
  avaliacoes:any = [];

  constructor(public navCtrl: NavController, public navParams: NavParams, private share:ShareService) {
  this.usuario = this.navParams.get('usuario');
  }
  
  verAvaliacao(id){
    let aval = this.avaliacoes.find(x=> x.id == id);
    this.navCtrl.push(VerAvaliacaoPage, {avaliacao: aval, usuario: this.usuario, excluir: true}, {animate: true});
  }

  ionViewWillEnter(){
    this.carregaAvaliacoes();
  }

  carregaAvaliacoes() {
    
    this.share.retornaAvaliacoesCliente(this.usuario.id).subscribe((data:any)=>{
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

  novaAvaliacao(){
    this.navCtrl.push(NovaAvaliacaoPage, {usuario: this.usuario});
  }

  menu(){
    this.navCtrl.push(InicioPage, { usuario: this.usuario }, { animate: true });
  }
  
  acessarPerfil() {
    this.navCtrl.push(UsuarioPage, { usuario: this.usuario, clienteOuEstab: 0 },
      { animate: true });
  }

}
