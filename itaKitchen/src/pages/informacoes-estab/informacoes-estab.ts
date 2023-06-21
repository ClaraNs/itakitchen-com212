import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams } from 'ionic-angular';
import { NovaAvaliacaoPage } from '../nova-avaliacao/nova-avaliacao';
import { InicioPage } from '../inicio/inicio';
import { UsuarioPage } from '../usuario/usuario';
import { MinhasAvaliacoesPage } from '../minhas-avaliacoes/minhas-avaliacoes';
import { ShareService } from '../share/share';

/**
 * Generated class for the InformacoesEstabPage page.
 *
 * See https://ionicframework.com/docs/components/#navigation for more info on
 * Ionic pages and navigation.
 */

@IonicPage()
@Component({
  selector: 'page-informacoes-estab',
  templateUrl: 'informacoes-estab.html',
})
export class InformacoesEstabPage {

  idestab: any;
  usuario: any;
  estab: any = {};
  endereco: any = {};
  horario: any = {};

  constructor(public navCtrl: NavController, public navParams: NavParams, private share: ShareService) {
    this.idestab = this.navParams.get('idestab');
    this.usuario = this.navParams.get("usuario");
    this.carregarEstabelecimento();
  }

  formatarCNPJ(cnpj: string): string {
    return cnpj.replace(/^(\d{2})(\d{3})(\d{3})(\d{4})(\d{2})$/, '$1.$2.$3/$4-$5');
  }

  carregarEstabelecimento() {
    this.share.retornaEstabelecimentoPorID(this.idestab).subscribe((data: any) => {
      console.log(data[0].id)
      this.share.retornaNumAvaliacoesPorEstab(data[0].id).subscribe((data2: any) => {

        let estab = {
          id: data[0].id,
          nome: data[0].nome,
          cnpj: data[0].cnpj,
          textocnpj: this.formatarCNPJ(data[0].cnpj), 
          descricao: data[0].descricao,
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
        console.log(estab);

        this.share.retornaHorario(estab.idhorariofunc).subscribe((data3: any) => {
          let y = data3[0];
          console.log(y)
          this.horario = {
            hdomingoinicio: this.formataHora(y.hDomingoInicio),
            hdomingofim: this.formataHora(y.hDomingoFim),
            hsegundainicio: this.formataHora(y.hSegundaInicio),
            hsegundafim:this.formataHora( y.hSegundaFim),
            htercainicio: this.formataHora(y.hTercaInicio),
            htercafim: this.formataHora(y.hTercaFim),
            hquartainicio: this.formataHora(y.hQuartaInicio),
            hquartafim: this.formataHora(y.hQuartaFim),
            hquintainicio: this.formataHora(y.hQuintaInicio),
            hquintafim: this.formataHora(y.hQuintaFim),
            hsextainicio: this.formataHora(y.hSextaInicio),
            hsextafim: this.formataHora(y.hSextaFim),
            hsabadoinicio: this.formataHora(y.hSabadoInicio),
            hsabadofim: this.formataHora(y.hSabadoFim)
          }
        });


        this.share.retornaEndereco(estab.idendereco).subscribe((data4: any) => {
          let x = data4[0];
          this.endereco = {
            rua: x.rua,
            bairro: x.bairro,
            numero: x.numero,
            cep: x.cep,
            complemento: x.complem,
            textocep: x.cep.slice(0, 5) + '-' + x.cep.slice(5),
          }
        });
      });

    });
  }

  formataHora(hora){
    return hora.slice(0,2) + 'h' + hora.slice(3, 5);
  }


  novaAvaliacao() {
    this.navCtrl.push(NovaAvaliacaoPage, { usuario: this.usuario });
  }

  menu() {
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

}
