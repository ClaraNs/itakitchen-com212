import { Component } from '@angular/core';
import { AlertController, IonicPage, NavController, NavParams, Toast, ToastController } from 'ionic-angular';
import { ShareService } from '../share/share';
import { Storage } from '@ionic/storage';
import { EditarClientePage } from '../editar-cliente/editar-cliente';
import { MinhasAvaliacoesPage } from '../minhas-avaliacoes/minhas-avaliacoes';
import { InicioPage } from '../inicio/inicio';
/**
 * Generated class for the UsuarioPage page.
 *
 * See https://ionicframework.com/docs/components/#navigation for more info on
 * Ionic pages and navigation.
 */

@IonicPage()
@Component({
  selector: 'page-usuario',
  templateUrl: 'usuario.html',
})
export class UsuarioPage {

  usuario: any = null;
  imagemURL: any = null;
  numavaliacoes: any = 0;
  clienteOuEstab:any = 0; // 0 - cliente 1 - estabelecimento

  constructor(public navCtrl: NavController, public navParams: NavParams, private share: ShareService,
    private alertCtrl: AlertController, private toastCtrl: ToastController, public storage: Storage) {
    this.usuario = this.navParams.get("usuario");
    this.imagemURL = 'data:image/png;base64,' + this.usuario.foto;
    if(this.usuario.cnpj != undefined){
      this.clienteOuEstab = 1;
    }
    this.retornaNumAvaliacoes();
  }

  minhasAvaliacoes() {
    this.navCtrl.push(MinhasAvaliacoesPage, { usuario: this.usuario, clienteOuEstab: this.clienteOuEstab },
      { animate: true });
  }


  editarPerfil() {
    if (this.usuario.cpf != undefined) {
      this.navCtrl.push(EditarClientePage, { usuario: this.usuario }, { animate: true });
    } else {

    }
  }

  retornaNumAvaliacoes() {
    if (this.usuario.cpf != undefined) {
      this.share.retornaNumAvaliacoes(this.usuario.id).subscribe((data: any) => {
        this.numavaliacoes = data[0];
      });
    } else {
      this.share.retornaNumAvaliacoesPorEstab(this.usuario.id).subscribe((data: any) => {
        this.numavaliacoes = data[0][0];
      });
    }
  }

  sair() {
    this.navCtrl.pop();
    this.navCtrl.pop();
  }

  inicio() {
    this.navCtrl.push(InicioPage, { usuario: this.usuario }, { animate: true });
  }

  confirmaExclusao() {
    const confirm = this.alertCtrl.create({
      title: 'Excluir Usuário',
      message: 'Deseja mesmo excluir seu cadastro? Ficamos tristes com sua partida...',
      buttons: [
        {
          text: 'Não',
          handler: () => {

          }
        },
        {
          text: 'Sim',
          handler: () => {
            this.deletaUsuario();
          }
        }
      ]
    });
    confirm.present();
  }

  deletaUsuario() {
    if (this.usuario.cpf != undefined) {
      this.share.excluirUsuario(this.usuario.id).subscribe(async (data: any) => {
        if (data == 1) {
          let toast = this.toastCtrl.create({
            message: "Usuário deletado com sucesso!",
            duration: 2000
          });
          toast.present();
          await this.storage.clear();
          this.sair();

        }
      });

    } else {
      this.share.excluirEstab(this.usuario.id).subscribe(async (data: any) => {
        if (data == 1) {
          let toast = this.toastCtrl.create({
            message: "Usuário deletado com sucesso!",
            duration: 2000
          });
          toast.present();
          await this.storage.clear();
          this.sair();

        }
      });
    }
  }

}
